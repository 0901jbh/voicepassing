package com.ssafy.voicepassing.model.service;

import lombok.RequiredArgsConstructor;
import org.springframework.core.io.FileSystemResource;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AnalysisServiceImpl implements AnalysisService{



    //@Value("${fastapi.url}")
    private String fastApiUrl;

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
