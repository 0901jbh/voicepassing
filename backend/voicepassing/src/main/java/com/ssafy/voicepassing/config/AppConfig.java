package com.ssafy.voicepassing.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.server.standard.ServletServerContainerFactoryBean;

@Configuration
public class AppConfig {

	@Bean
	public ServletServerContainerFactoryBean createServletServerContainerFactoryBean() {
	    ServletServerContainerFactoryBean container = new ServletServerContainerFactoryBean();
	    container.setMaxTextMessageBufferSize(98730540);
	    container.setMaxBinaryMessageBufferSize(98730540);
	    return container;
	}
}
