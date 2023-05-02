package com.ssafy.voicepassing.controller;


import com.ssafy.voicepassing.model.dto.ResultDTO;
import com.ssafy.voicepassing.model.service.AnalysisService;
import com.ssafy.voicepassing.model.service.ResultService;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;


@RestController
@RequestMapping("/api/analysis")
@Tag(name="[Analysis] analysis API")
@Slf4j
@RequiredArgsConstructor
public class AnalysisController {

    private static final Logger logger = LoggerFactory.getLogger(AnalysisController.class);
    private final ResultService resultService;

    private final AnalysisService analysisService;





    @PostMapping("/colva")
    public ResponseEntity<?> clova(){
        String text = analysisService.SpeechToText();
        return ResponseEntity.ok("File uploaded");
    }

    @PostMapping("/AI")
    public ResponseEntity<?> getAI(@RequestBody ResultDTO.Send rb){
        HttpStatus status = HttpStatus.OK;
        Map<String, Object> resultMap = new HashMap<>();
        System.out.println("1 :" + rb.getText());
        resultMap = analysisService.recommend2(rb);

        return new ResponseEntity<Map<String,Object>>(resultMap,status);
    }



    @PostMapping("/convert")
    public String convert(@RequestParam("file") MultipartFile file) throws Exception {

        File inputFile = File.createTempFile("input", ".m4a");
        file.transferTo(inputFile);

        File outputFile = File.createTempFile("output", ".mp3");
      //  AudioConverter.convertToMP3(inputFile, outputFile);

        return outputFile.getAbsolutePath();
    }



    @PostMapping("/file")
    public ResponseEntity<?> handleFileUpload(@RequestParam("file") MultipartFile file) throws IOException {
       String str = analysisService.uploadFile(file);


        return ResponseEntity.ok("File uploaded");
    }


}
