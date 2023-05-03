package com.ssafy.voicepassing.config.handler;


import java.io.File;
import java.io.FileOutputStream;
import java.io.UnsupportedEncodingException;
import java.nio.ByteBuffer;
import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.BinaryMessage;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.AbstractWebSocketHandler;

import com.ssafy.voicepassing.util.RestAPIUtil;

@Component
public class AudioWebSocketHandler extends AbstractWebSocketHandler {
	private static final Logger logger = LoggerFactory.getLogger(AudioWebSocketHandler.class);
	
	@Autowired
	private RestAPIUtil restApiUtil;
	
	
	@Value("${SPRING_RECORD_TEMP_DIR}")
	private String RECORD_PATH;
	
	@Value("${DOMAIN_UNTRUNC}")
	private String DOMAIN_UNTRUNC;
	
	
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		super.afterConnectionEstablished(session);
		
		File directory = new File(RECORD_PATH+"/"+session.getId());
        if (!directory.exists()) {
            directory.mkdir();
			File partDirectory = new File(RECORD_PATH+"/"+session.getId()+"/part");
			partDirectory.mkdir();
            logger.info("디렉터리 생성 완료");
        } else {
        	logger.info("이미 디렉터리가 존재합니다.");
        }
		logger.info("소켓연결시작: {}", session.getId());
	}

	@Override
	public void handleBinaryMessage(WebSocketSession session, BinaryMessage message) throws Exception{
		logger.info("bin sessiong request: {}", session.getId());
		ByteBuffer byteBuffer = message.getPayload();
		
		FileOutputStream outputStream = new FileOutputStream(RECORD_PATH + "/" + session.getId() + "/record.m4a",true);
		byte[] bytes = new byte[byteBuffer.remaining()];
		byteBuffer.get(bytes);
		outputStream.write(bytes);
		outputStream.close();
		
		logger.info("URL : {}",DOMAIN_UNTRUNC);
		String URL = DOMAIN_UNTRUNC+"/recover";
		Map<String, String> params = new HashMap<>();
		params.put("sessionId", session.getId());
		
		Map<String, Object> result = restApiUtil.requestGet(URL, params);
		logger.info("결과 : {}", result);
	}

	@Override
	public void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		logger.info("소켓텍스트: {}", message);
		logger.info("바이너리 변환: {}", message.getPayload().getBytes("utf-8"));
		
	}

	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		File directoryToDelete = new File(RECORD_PATH+"/"+session.getId());
		if (directoryToDelete.exists()) {
            deleteDirectory(directoryToDelete);
            logger.info("디렉터리 삭제 완료");
        } else {
        	logger.info("삭제할 디렉터리가 존재하지 않습니다.");
        }
		logger.info("소켓연결해제: {}", session.getId());
		
	}
	
	
    // 디렉터리 삭제 메서드
    public static void deleteDirectory(File directory) {
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
