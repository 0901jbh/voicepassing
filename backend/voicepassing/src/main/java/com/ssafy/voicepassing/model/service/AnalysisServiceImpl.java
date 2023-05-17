package com.ssafy.voicepassing.model.service;

import com.ssafy.voicepassing.model.dto.AIResponseDTO;
import com.ssafy.voicepassing.model.dto.ResultDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;

@Service
@RequiredArgsConstructor
public class AnalysisServiceImpl implements AnalysisService{

    @Value("${SPRING_RECORD_TEMP_DIR}")//C:\Users\SSAFY\Desktop\test
    private String RECORD_PATH; //확인완료

    
    @Value("${AI_SERVER_URI}")
    private String AI_SERVER_URI;
    
    //@Value("${fastapi.url}")
    private String fastApiUrl;



    //Clova : file -> text
    @Override
    public String SpeechToText(String sessionId,String fileName) {
        String clientId = "69z4ol7120";             // Application Client ID";
        String clientSecret = "BgrF1fA39jXxMM2v9OLdzIQMl4JNbjMBg17uptzP";     // Application Client Secret";


        try {
            String imgFile = RECORD_PATH+"/"+sessionId+"/part/"+fileName;
            File voiceFile = new File(imgFile);

            String language = "Kor";        // 언어 코드 ( Kor, Jpn, Eng, Chn )
            String apiURL = "https://naveropenapi.apigw.ntruss.com/recog/v1/stt?lang=" + language;
            URL url = new URL(apiURL);

            HttpURLConnection conn = (HttpURLConnection)url.openConnection();
            conn.setUseCaches(false);
            conn.setDoOutput(true);
            conn.setDoInput(true);
            conn.setRequestProperty("Content-Type", "application/octet-stream");
            conn.setRequestProperty("X-NCP-APIGW-API-KEY-ID", clientId);
            conn.setRequestProperty("X-NCP-APIGW-API-KEY", clientSecret);

            OutputStream outputStream = conn.getOutputStream();
            FileInputStream inputStream = new FileInputStream(voiceFile);
            byte[] buffer = new byte[4096];
            int bytesRead = -1;
            while ((bytesRead = inputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }
            outputStream.flush();
            inputStream.close();
            BufferedReader br = null;
            int responseCode = conn.getResponseCode();
            if(responseCode == 200) { // 정상 호출
                br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            } else {  // 오류 발생
                br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            }
            String inputLine;

            if(br != null) {
                StringBuffer response = new StringBuffer();
                while ((inputLine = br.readLine()) != null) {
                    response.append(inputLine);
                }
                br.close();
                String result = response.toString();
                result = result.substring(9,result.length()-2);
                return result;
            } else {

            }
        } catch (Exception e) {
        }
        return "error";
    }

    //text -> result 받기
    @Override
    public Map<String, Object> analysis(AIResponseDTO.Request rb) {
        Map<String, Object> resultMap = new HashMap<>();
        RestTemplate restTemplate = new RestTemplate();

//    // 요청 Body 생성
		Map<String, Object> requestBody = new HashMap<>();
		requestBody.put("text", rb.getText());
		requestBody.put("isFinish", Boolean.toString(rb.isFinish()));
		requestBody.put("sessionId", rb.getSessionId());

//    // HTTP Header 생성
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);

//    // HTTP 요청 생성
		HttpEntity<Map<String, Object>> httpEntity = new HttpEntity<>(requestBody, headers);

//    // FastAPI URL 설정
		String url = AI_SERVER_URI + "/inference";

//    // HTTP 요청 보내기
		ResponseEntity<AIResponseDTO.Response> responseEntity = restTemplate.postForEntity(url, httpEntity,
				AIResponseDTO.Response.class);

//
//// HTTP 응답 받기
		AIResponseDTO.Response responseBody = responseEntity.getBody();
		resultMap.put("status", responseEntity.getStatusCode());
		resultMap.put("result", responseBody);

		return resultMap;
	}

	public String maskingData(String data) {
		StringBuilder sb = new StringBuilder(data);
		StringBuilder mask = new StringBuilder();
		for(int i = 0 ; i < sb.length();i++) {
			char target = sb.charAt(i);
			if(target>='0'&& target<='9') {
				mask.append('0');
			}else {
				mask.append(target);
			}
		}
		return mask.toString();
	}
}
