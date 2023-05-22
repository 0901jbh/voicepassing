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
import com.ssafy.voicepassing.model.dto.AIResponseDTO;
import com.ssafy.voicepassing.model.dto.KeywordDTO;
import com.ssafy.voicepassing.model.dto.KeywordSentenceDTO;
import com.ssafy.voicepassing.model.dto.ResultDTO;
import com.ssafy.voicepassing.model.dto.ResultDetailDTO;
import com.ssafy.voicepassing.model.entity.Keyword;
import com.ssafy.voicepassing.model.entity.KeywordSentence;
import com.ssafy.voicepassing.model.service.AnalysisService;
import com.ssafy.voicepassing.model.service.KeywordSentenceService;
import com.ssafy.voicepassing.model.service.KeywordService;
import com.ssafy.voicepassing.model.service.ResultDetailService;
import com.ssafy.voicepassing.model.service.ResultService;
import com.ssafy.voicepassing.util.RestAPIUtil;

@Component
public class AudioWebSocketHandler extends AbstractWebSocketHandler {
	private static final Logger logger = LoggerFactory.getLogger(AudioWebSocketHandler.class);

	@Autowired
	private RestAPIUtil restApiUtil;

	@Autowired
	private AnalysisService analysisService;
	
	@Autowired
	private ResultService resultService;

	@Autowired
	private KeywordService keywordService;

	@Autowired
	private KeywordSentenceService keywordSentenceService;

	@Autowired
	private ResultDetailService resultDetailService;
	

	@Value("${SPRING_RECORD_TEMP_DIR}")
	private String RECORD_PATH;

	@Value("${DOMAIN_UNTRUNC}")
	private String DOMAIN_UNTRUNC;

	@Value("${AI_SERVER_URI}")
	private String AI_SERVER_URI;
	
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		super.afterConnectionEstablished(session);
		createFolder(session.getId());
	}

	@Override
	public void handleBinaryMessage(WebSocketSession session, BinaryMessage message) throws Exception {
		logger.info("bin sessiong request: {}", session.getId());
		Map<String, Object> sessionAttribute = session.getAttributes();

		appendFile(message.getPayload(), session.getId());

//		int startValue = (int) sessionAttribute.get("start");
//		sessionAttribute.put("start", startValue + 1);

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
		sendAiServer(newFile, newFilePath, session, false);

	}

	@Override
	public void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		logger.info("socket 정보 전달받음 : {}", message);
		Gson gson = new Gson();
		Map<String, Object> messageMap = gson.fromJson(message.getPayload(), Map.class);
		int stateValue = (int)Math.floor((double)messageMap.get("state"));
		String androidId = (String)messageMap.getOrDefault("androidId","tempId");
		session.getAttributes().put("androidId", androidId);
		switch (stateValue) {
		case 0: 
			logger.info("Send session info : {} , androidId : {}", session.getId(), androidId);
			break;
		case 1:
			String phoneNumber = (String)messageMap.getOrDefault("phoneNumber","010-1234-1234");
			session.getAttributes().put("phoneNumber", phoneNumber);
			
			String untruncUrl = DOMAIN_UNTRUNC + "/recover";
			Map<String, String> params = new HashMap<>();
			params.put("sessionId", session.getId());
			params.put("state", "2");
			Map<String, Object> untruncResult = restApiUtil.requestGet(untruncUrl, params);

			List<String> newFile = (List<String>) untruncResult.get("new_file");
			String newFilePath = RECORD_PATH + "/" + session.getId() + "/part/";
			sendAiServer(newFile, newFilePath, session, true);
			break;
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
	public void sendClient(WebSocketSession session, Map<String, Object> result)
			throws IOException {
		Gson gson = new Gson();
		String json = gson.toJson(result);
		TextMessage textMessage = new TextMessage(json);
		
		AIResponseDTO.Response aiDTO = gson.fromJson(gson.toJson(result.get("result")),AIResponseDTO.Response.class);
		boolean isFinish = (Boolean)result.get("isFinish");
			
		session.sendMessage(textMessage);
		
		if(isFinish && aiDTO.getTotalCategory()!=0) { //result처리 , 60%이상인 데이터만 우선 insert
			String androidId = (String) session.getAttributes().get("androidId");
			String phoneNumber = (String) session.getAttributes().get("phoneNumber");
			logger.info("안드로이드 : {}  폰번호 : {}  로그기록을 시작합니다.",androidId,phoneNumber );
			dataInput(aiDTO, phoneNumber, androidId);
		}
		
	}

	// 새로생성된 part파일을 분석하고 보내는 것 까지
	public void sendAiServer(List<String> newFile, String newFilePath, WebSocketSession session,Boolean isFinish) throws Exception {
		for (int i = 0; i < newFile.size(); i++) {

			String filePath = newFilePath + newFile.get(i);
			String myUrl = "http://localhost:8080/api/analysis/file2text";
			MultiValueMap<String, Object> mybody = new LinkedMultiValueMap<>();
			mybody.add("sessionId", session.getId());
			mybody.add("filepath", filePath);
			mybody.add("isFinish", (isFinish&&i==newFile.size()-1));

			logger.info("클로바 요청 {} 시작 {} , {}: ", i , filePath,mybody);
			Map<String, Object> myResult = restApiUtil.requestPost(myUrl, mybody);
			myResult.put("isFinish", isFinish&&i==newFile.size()-1);

			sendClient(session, myResult);
			logger.info("클로바 요청 {} 결과: {}", i, myResult);
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

	
	public void dataInput(AIResponseDTO.Response rep,String phoneNumber,String androidId) {

        ResultDTO.Result res = ResultDTO.Result.builder()
                .androidId(androidId)
                .phoneNumber(phoneNumber)
                .category(rep.getTotalCategory())
                .risk(rep.getTotalCategoryScore())
                .build();

        int rId = resultService.addResult(res);



        List<AIResponseDTO.Result> resultList = rep.getResults();

        for (AIResponseDTO.Result r : resultList) {
        	KeywordDTO.Keyword keywordDTO = KeywordDTO.Keyword.builder()
                    .keyword(r.getSentKeyword())
                    .category(r.getSentCategory())
                    .count(0)
                    .build();

            Keyword k = keywordService.addKeywordReturn(keywordDTO);
        	
            KeywordSentenceDTO.KeywordSentence ksDTO = KeywordSentenceDTO.KeywordSentence
                    .builder()
                    .score(r.getSentCategoryScore())
                    .keyword(k.getKeyword())
                    .sentence(r.getSentence())
                    .category(k.getCategory())
                    .build();
            KeywordSentence ksb = keywordSentenceService.addKeywordSentenceReturn(ksDTO);
            
            ResultDetailDTO.ResultDetail rdDTO = ResultDetailDTO.ResultDetail.
                    builder()
                    .resultId(rId)
                    .sentence(ksb.getSentence())
                    .build();
            int rgd = resultDetailService.addResultDetail(rdDTO);
        }

    
	}
	
}
