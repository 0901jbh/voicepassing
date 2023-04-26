package com.ssafy.voicepassing.config.handler;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.AbstractWebSocketHandler;

@Component
public class AudioWebSocketHandler extends AbstractWebSocketHandler {
	private static final Logger logger = LoggerFactory.getLogger(AudioWebSocketHandler.class);
	
	@Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        super.afterConnectionEstablished(session);
        logger.info("소켓연결시작: {}", session.getId());
    }
	
	
	@Override
    public void handleMessage(WebSocketSession session, WebSocketMessage<?> message) {
		logger.info("소켓메세지: {}", message);
	    
    }
	
	@Override
	public void handleTextMessage(WebSocketSession session, TextMessage message) {
		logger.info("소켓텍스트: {}", message);
	}
 
    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        // 클라이언트와의 WebSocket 연결이 종료된 후에 호출됨
    	logger.info("소켓연결해제: {}", session.getId());
    }
}
