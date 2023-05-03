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

    //@Value("${fastapi.url}")
    private String fastApiUrl;

    //clova upload file to text
    @Override
    public String FileSpeechToText(MultipartFile file) throws IOException {
        String clientId = "69z4ol7120";             // Application Client ID";
        String clientSecret = "BgrF1fA39jXxMM2v9OLdzIQMl4JNbjMBg17uptzP";     // Application Client Secret";
        System.out.println("파일 찾기 전");
        File voiceFile = mTF(file);
        System.out.println("파일 찾기 후");
        System.out.println("여기서 나가지나?");
        try {
            //String imgFile = RECORD_PATH+"/1.m4a";
            //File voiceFile = new File(imgFile);

            //File voiceFile = file;

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
            System.out.println("살아있나?");
            OutputStream outputStream = conn.getOutputStream();
            System.out.println("진짜여기");
            FileInputStream inputStream = new FileInputStream(voiceFile);
            System.out.println("여기다");
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
            System.out.println("문제");
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
                System.out.println("error !!!");

            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return "error";
    }

    public File mTF(MultipartFile mfile) throws IOException {
        File file = new File(mfile.getOriginalFilename());
        mfile.transferTo(file);
        return file;
    }

    //Clova : file -> text
    @Override
    public String SpeechToText() {
        String clientId = "69z4ol7120";             // Application Client ID";
        String clientSecret = "BgrF1fA39jXxMM2v9OLdzIQMl4JNbjMBg17uptzP";     // Application Client Secret";


        try {
            String imgFile = RECORD_PATH+"/1.mp3";
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
                String result = response.toString();
                result = result.substring(9,result.length()-2);
                return result;
            } else {
                System.out.println("error !!!");

            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return "error";
    }

    //text -> result 받기
    @Override
    public Map<String, Object> recommend(AIResponseDTO.Request rb) {
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
        String url = "http://localhost:8000/inference";

//    // HTTP 요청 보내기
        ResponseEntity<AIResponseDTO.Response> responseEntity = restTemplate.postForEntity(url,httpEntity,AIResponseDTO.Response.class);

//
//// HTTP 응답 받기
        AIResponseDTO.Response responseBody = responseEntity.getBody();
        resultMap.put("result",responseBody);

        return resultMap;
    }

    //front return test
    @Override
    public Map<String, Object> getResult(AIResponseDTO.Request rb) {
        Map<String, Object> resultMap = new HashMap<>();

        AIResponseDTO.Result r = AIResponseDTO.Result.builder()
                .sentCategory(1)
                .sentCategoryScore((float)2.3)
                .sentKeyword("경찰")
                .keywordScore((float)1.1)
                .sentence("경찰청 수사반입니다")
                .build();

        AIResponseDTO.Result r2 = AIResponseDTO.Result.builder()
                .sentCategory(1)
                .sentCategoryScore((float)3.4)
                .sentKeyword("수사반")
                .keywordScore((float)1.11)
                .sentence("경찰청 수사반입니다")
                .build();

        List<AIResponseDTO.Result> results = new ArrayList<>();
        results.add(r);
        results.add(r2);

        AIResponseDTO.Response result = AIResponseDTO.Response.builder()
                .totalCategory(1)
                .totalCategoryScore(90)
                .results(results)
                .build();

        System.out.println(result.getTotalCategory());
        System.out.println(result.getTotalCategoryScore());

        resultMap.put("result",result);

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
