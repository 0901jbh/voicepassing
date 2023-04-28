package com.ssafy.voicepassing.config.handler;


import java.io.File;
import java.io.FileOutputStream;
import java.nio.ByteBuffer;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.BinaryMessage;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.AbstractWebSocketHandler;


@Component
public class AudioWebSocketHandler extends AbstractWebSocketHandler {
	private static final Logger logger = LoggerFactory.getLogger(AudioWebSocketHandler.class);
	@Value("${SPRING_RECORD_TEMP_DIR}")
	private String RECORD_PATH;
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		super.afterConnectionEstablished(session);
		File directory = new File(RECORD_PATH+"/"+session.getId());
        if (!directory.exists()) {
            directory.mkdir();
            System.out.println("디렉터리 생성 완료");
        } else {
            System.out.println("이미 디렉터리가 존재합니다.");
        }
		logger.info("소켓연결시작: {}", session.getId());
	}

	@Override
	public void handleBinaryMessage(WebSocketSession session, BinaryMessage message) {
		logger.info("bin sessiong request: {}", session.getId());
		ByteBuffer byteBuffer = message.getPayload();
		try (FileOutputStream outputStream = new FileOutputStream(RECORD_PATH + "/" + session.getId() + "/record.m4a",true)) {
			byte[] bytes = new byte[byteBuffer.remaining()];
			byteBuffer.get(bytes);
			outputStream.write(bytes);
			outputStream.close();
			
		}catch (Exception e) {
			logger.error("Error saving file", e);
		}

	}

	@Override
	public void handleTextMessage(WebSocketSession session, TextMessage message) {
		logger.info("소켓텍스트: {}", message);
	}

	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		File directoryToDelete = new File(RECORD_PATH+"/"+session.getId());
		if (directoryToDelete.exists()) {
            deleteDirectory(directoryToDelete);
            System.out.println("디렉터리 삭제 완료");
        } else {
            System.out.println("삭제할 디렉터리가 존재하지 않습니다.");
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
