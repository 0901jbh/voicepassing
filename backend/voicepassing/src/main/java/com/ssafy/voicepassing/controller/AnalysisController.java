package com.ssafy.voicepassing.controller;


import com.ssafy.voicepassing.model.service.AnalysisService;
import com.ssafy.voicepassing.model.service.ResultService;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;

@RestController
@RequestMapping("/api/analysis")
@Tag(name="[Analysis] analysis API")
@Slf4j
@RequiredArgsConstructor
public class AnalysisController {

    private static final Logger logger = LoggerFactory.getLogger(AnalysisController.class);
    private final ResultService resultService;

    private final AnalysisService analysisService;





    @PostMapping("/clova")
    public ResponseEntity<?> SpeechToText(@RequestParam("file") MultipartFile file) throws IOException {
        //서비스 호출

        //text 파일


        //내부에 저장? 파일 리턴

        String str = analysisService.uploadFile(file);


        return ResponseEntity.ok("File uploaded");
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
