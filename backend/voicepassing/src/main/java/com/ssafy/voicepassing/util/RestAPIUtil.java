package com.ssafy.voicepassing.util;

import lombok.RequiredArgsConstructor;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.*;
import org.springframework.stereotype.Component;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.util.Map;

@Component
@RequiredArgsConstructor
public class RestAPIUtil {
	private static final Logger logger = LoggerFactory.getLogger(RestAPIUtil.class);
	
	public Map<String, Object> requestGet(String domain, Map<String, String> params) throws Exception {
        RestTemplate restTemplate = new RestTemplate();
        UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(domain);

        for (Map.Entry<String, String> entry : params.entrySet()) {
            builder.queryParam(entry.getKey(), entry.getValue());
        }

        String url = builder.toUriString();

        logger.info("요청URI GET : {}", url);
        ResponseEntity<Map<String, Object>> response = restTemplate.exchange(url, HttpMethod.GET,
                null, new ParameterizedTypeReference<Map<String, Object>>() {});

        if (response.getStatusCode() == HttpStatus.OK) {
            Map<String, Object> result = response.getBody();
            logger.info("성공유무 : {}", result.get("msg"));
            return result;
        } else {
            logger.info("Error: {}", response.getStatusCodeValue());
        }
        return null;
    }
	
	
	public Map<String, Object> requestPost(String url,MultiValueMap<String, Object> body) throws Exception {
		RestTemplate restTemplate = new RestTemplate();

		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.MULTIPART_FORM_DATA);

		HttpEntity<MultiValueMap<String, Object>> requestEntity = new HttpEntity<>(body, headers);
		logger.info("요청URI POST : {}", url);
		ResponseEntity<Map<String, Object>> response = restTemplate.exchange(url, HttpMethod.POST,
				requestEntity, new ParameterizedTypeReference<Map<String, Object>>() {
				});

		if (response.getStatusCode() == HttpStatus.OK) {
			Map<String, Object> result = response.getBody();
			logger.info("성공유무 : {}" ,result.get("msg"));
			return result;
		} else {
			logger.info("Error: {}",response.getStatusCodeValue());
		}
		return null;
	}


}