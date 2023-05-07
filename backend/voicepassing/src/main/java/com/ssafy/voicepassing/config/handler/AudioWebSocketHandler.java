package com.ssafy.voicepassing.config.handler;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.nio.ByteBuffer;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.socket.BinaryMessage;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.AbstractWebSocketHandler;
import com.google.gson.Gson;

import com.ssafy.voicepassing.model.service.AnalysisService;
import com.ssafy.voicepassing.util.RestAPIUtil;

@Component
public class AudioWebSocketHandler extends AbstractWebSocketHandler {
	private static final Logger logger = LoggerFactory.getLogger(AudioWebSocketHandler.class);

	@Autowired
	private RestAPIUtil restApiUtil;

	@Autowired
	private AnalysisService analysisService;

	@Value("${SPRING_RECORD_TEMP_DIR}")
	private String RECORD_PATH;

	@Value("${DOMAIN_UNTRUNC}")
	private String DOMAIN_UNTRUNC;

	@Value("${AI_SERVER_URI}")
	private String AI_SERVER_URI;
	
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		super.afterConnectionEstablished(session);
		Map<String, Object> sessionAttribute = session.getAttributes();
		sessionAttribute.put("start", 0);
		sessionAttribute.put("end", 0);
	}

	@Override
	public void handleBinaryMessage(WebSocketSession session, BinaryMessage message) throws Exception {
		logger.info("bin sessiong request: {}", session.getId());
		Map<String, Object> sessionAttribute = session.getAttributes();

		appendFile(message.getPayload(), session.getId());

		int startValue = (int) sessionAttribute.get("start");
		sessionAttribute.put("start", startValue + 1);

		logger.info("GET 요청 (복원): {}", DOMAIN_UNTRUNC + "/recover");

		String untruncUrl = DOMAIN_UNTRUNC + "/recover";
		Map<String, String> params = new HashMap<>();
		params.put("sessionId", session.getId());
		params.put("state", "1");
		Map<String, Object> untruncResult = restApiUtil.requestGet(untruncUrl, params);

		logger.info("결과 (복원): {}", untruncResult);

		// 15초단위 추가 파일
		List<String> newFile = (List<String>) untruncResult.get("new_file");
		String newFilePath = RECORD_PATH + "/" + session.getId() + "/part/";
		sendAiServer(newFile, newFilePath, session);

		int endValue = (int) sessionAttribute.get("end");
		sessionAttribute.put("start", endValue + 1);
	}

	@Override
	public void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		logger.info("socket 정보 전달받음 : {}", message);

		Gson gson = new Gson();
		Map<String, Object> messageMap = gson.fromJson(message.getPayload(), Map.class);

		int stateValue = (Integer) messageMap.get("state");

		switch (stateValue) {
		case 0:
			logger.info("통화 받음 폴더 생성 : {}", session.getId());
			createFolder(session.getId());
			break;
		case 1:
			logger.info("상태확인 start,end가 일치해야 이전과정이 끝났다는 것");
			Map<String, Object> sessionAttribute = session.getAttributes();
			int start = (int) sessionAttribute.get("start");
			int end = (int) sessionAttribute.get("end");
			Map<String, Boolean> result = new HashMap<>();
			result.put("isFinish", start == end);

			String jsonResult = gson.toJson(result);
			TextMessage resultMessage = new TextMessage(jsonResult);
			session.sendMessage(resultMessage);

			break;
		case 2:
			logger.info("통화 종료");
			String untruncUrl = DOMAIN_UNTRUNC + "/recover";
			Map<String, String> params = new HashMap<>();
			params.put("sessionId", session.getId());
			params.put("state", "2");
			Map<String, Object> untruncResult = restApiUtil.requestGet(untruncUrl, params);

			List<String> newFile = (List<String>) untruncResult.get("new_file");
			String newFilePath = RECORD_PATH + "/" + session.getId() + "/part/";
			sendAiServer(newFile, newFilePath, session);
			//여기까지 15초 단위 마지막 부분 전부 처리
			
			
			//여기에 ai분석 마지막 요약 전송하기
			String aiDomain = AI_SERVER_URI + "/inference";
			MultiValueMap<String, Object> mybody = new LinkedMultiValueMap<>();
			mybody.add("sessionId", session.getId());
			mybody.add("isFinish", true);
			mybody.add("text", "이상입니다.");
			Map<String, Object> aiResult = restApiUtil.requestPost(aiDomain, mybody);
			sendClient(session, aiResult);
		default:
			logger.info("error");
			break;
		}

	}

	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		File directoryToDelete = new File(RECORD_PATH + "/" + session.getId());
		if (directoryToDelete.exists()) {
			deleteDirectory(directoryToDelete);
			logger.info("디렉터리 삭제 완료");
		} else {
			logger.info("삭제할 디렉터리가 존재하지 않습니다.");
		}
		logger.info("소켓연결해제: {}", session.getId());

	}

	public void appendFile(ByteBuffer byteBuffer, String sessionId) throws IOException {
		FileOutputStream outputStream = new FileOutputStream(RECORD_PATH + "/" + sessionId + "/record.m4a", true);
		byte[] bytes = new byte[byteBuffer.remaining()];
		byteBuffer.get(bytes);
		outputStream.write(bytes);
		outputStream.close();
	}

	// 분석결과 전달하기
	public static void sendClient(WebSocketSession session, Map<String, Object> result)
			throws IOException {
		Gson gson = new Gson();
		String json = gson.toJson(result);
		TextMessage textMessage = new TextMessage(json);
		session.sendMessage(textMessage);
	}

	// 새로생성된 part파일을 분석하고 보내는 것 까지
	public void sendAiServer(List<String> newFile, String newFilePath, WebSocketSession session) throws Exception {
		for (int i = 0; i < newFile.size(); i++) {

			String filePath = newFilePath + newFile.get(i);
			String myUrl = "http://localhost:8080/api/analysis/reqfile";
			MultiValueMap<String, Object> mybody = new LinkedMultiValueMap<>();
			mybody.add("sessionId", session.getId());
			mybody.add("filepath", filePath);
			mybody.add("isFinish", 5);

			logger.info("클로바 요청{} 시작: {}", filePath);
			Map<String, Object> myResult = restApiUtil.requestPost(myUrl, mybody);
			sendClient(session, myResult);
			logger.info("클로바 요청{} 결과: {}", i, myResult);
		}
	}

	// 통화연결 시작했을 때 폴더생성
	public void createFolder(String sessionId) {
		File directory = new File(RECORD_PATH + "/" + sessionId);
		if (!directory.exists()) {
			directory.mkdir();
			File partDirectory = new File(RECORD_PATH + "/" + sessionId + "/part");
			partDirectory.mkdir();
			logger.info("디렉터리 생성 완료");
		} else {
			logger.info("이미 디렉터리가 존재합니다.");
		}
		logger.info("소켓연결시작: {}", sessionId);
	}

	// 디렉터리 삭제 메서드
	public void deleteDirectory(File directory) {
		File[] files = directory.listFiles();
		if (files != null) {
			for (File file : files) {
				if (file.isDirectory()) {
					deleteDirectory(file);
				} else {
					file.delete();
				}
			}
		}
		directory.delete();
	}

}
