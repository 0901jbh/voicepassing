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
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AnalysisServiceImpl implements AnalysisService{

    @Value("${SPRING_RECORD_TEMP_DIR}")//C:\Users\SSAFY\Desktop\test
    private String RECORD_PATH; //확인완료

    //@Value("${fastapi.url}")
    private String fastApiUrl;

    @Override
    public String SpeechToText() {
        //String clientId = "YOUR_CLIENT_ID";             // Application Client ID";
        //String clientSecret = "YOUR_CLIENT_SECRET";     // Application Client Secret";


        String clientId = "69z4ol7120";             // Application Client ID";
        String clientSecret = "BgrF1fA39jXxMM2v9OLdzIQMl4JNbjMBg17uptzP";     // Application Client Secret";


        try {
            String imgFile = RECORD_PATH+"/1.m4a";
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
                System.out.println("error!!!!!!! responseCode= " + responseCode);
                br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            }
            String inputLine;

            if(br != null) {
                StringBuffer response = new StringBuffer();
                while ((inputLine = br.readLine()) != null) {
                    response.append(inputLine);
                }
                br.close();
                System.out.println(response.toString());
                return response.toString();
            } else {
                System.out.println("error !!!");

            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return "error";
    }

    @Override
    public Map<String, Object> recommend(AIResponseDTO.Request rb) {
        Map<String, Object> resultMap = new HashMap<>();
        RestTemplate restTemplate = new RestTemplate();

//    // 요청 Body 생성
        Map<String, String> requestBody = new HashMap<>();
        requestBody.put("text", rb.getText());
        requestBody.put("isFinish", Boolean.toString(rb.isFinish()));
        requestBody.put("sessionId", rb.getSessionId());

//    // HTTP Header 생성
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

//    // HTTP 요청 생성
        HttpEntity<Map<String, String>> httpEntity = new HttpEntity<>(requestBody, headers);

//    // FastAPI URL 설정
        String url = "http://localhost:8000/inference";

//    // HTTP 요청 보내기
        ResponseEntity<AIResponseDTO.Result> responseEntity = restTemplate.postForEntity(url,httpEntity,AIResponseDTO.Result.class);

//
//// HTTP 응답 받기
        AIResponseDTO.Result responseBody = responseEntity.getBody();
        resultMap.put("result",responseBody);

        return resultMap;
    }

    @Override
    public Map<String, Object> recommend2(ResultDTO.Send rb) {
        Map<String, Object> resultMap = new HashMap<>();

        String text = rb.getText();
        RestTemplate restTemplate = new RestTemplate();

//    // 요청 Body 생성
        Map<String, String> requestBody = new HashMap<>();
        requestBody.put("text", text);
//        requestBody.put("isFinish", "false");
//        requestBody.put("sessionId", "abc");
//
//    // HTTP Header 생성
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
//
//    // HTTP 요청 생성
        HttpEntity<Map<String, String>> httpEntity = new HttpEntity<>(requestBody, headers);
//
//    // FastAPI URL 설정
        String url = "http://localhost:8000/inference";
//
//    // HTTP 요청 보내기
        ResponseEntity<ResultDTO.Temp> responseEntity = restTemplate.postForEntity(url,httpEntity,ResultDTO.Temp.class);

//
//// HTTP 응답 받기
        ResultDTO.Temp responseBody = responseEntity.getBody();
        resultMap.put("result",responseBody);

        return resultMap;
    }




    @Override
    public String uploadFile(MultipartFile file) throws IOException {
        String filename = file.getOriginalFilename();
        long fileSize = file.getSize();
        String contentType = file.getContentType();
        System.out.println("Received file: " + filename + ", size: " + fileSize + ", type: " + contentType);
        // 파일 처리 로직 작성
        // ...
        //String result =  uploadFileAI(file);
        return null;
    }


    public String uploadFileAI(MultipartFile multipartFile) throws IOException {
        String filename = multipartFile.getOriginalFilename();
        long fileSize = multipartFile.getSize();
        String contentType = multipartFile.getContentType();
        System.out.println("Received file: " + filename + ", size: " + fileSize + ", type: " + contentType);
        // Save the file locally to a temporary directory
        byte[] bytes = multipartFile.getBytes();
        Path tempDir = Files.createTempDirectory("upload");
        Path tempFile = Paths.get(tempDir.toString(), UUID.randomUUID().toString());
        Files.write(tempFile, bytes);

        // Create the request body
        MultiValueMap<String, Object> requestBody = new LinkedMultiValueMap<>();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.MULTIPART_FORM_DATA);

        requestBody.add("file", new FileSystemResource(tempFile.toFile()));

        HttpEntity<MultiValueMap<String, Object>> requestEntity = new HttpEntity<>(requestBody, headers);

        // Send the request to the fastapi server
        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<String> response = restTemplate.exchange(fastApiUrl, HttpMethod.POST, requestEntity, String.class);

        // Delete the temporary file
        Files.deleteIfExists(tempFile);

        return response.getBody();
    }
}
