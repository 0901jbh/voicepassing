package com.ssafy.voicepassing.controller;


import com.ssafy.voicepassing.model.dto.AIResponseDTO;
import com.ssafy.voicepassing.model.dto.ResultDTO;
import com.ssafy.voicepassing.model.service.AnalysisService;
import com.ssafy.voicepassing.model.service.ClovaSpeechService;
import com.ssafy.voicepassing.model.service.ResultService;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
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

    @Autowired
    private ClovaSpeechService clovaSpeechClient;
    
    ClovaSpeechService.NestRequestEntity requestEntity = new ClovaSpeechService.NestRequestEntity();


    @PostMapping("cs")
    public ResponseEntity<?> cs(){
        String result = null;
        String path = "C:\\Users\\SSAFY\\Desktop\\test\\1.mp3";
        result = clovaSpeechClient.upload(new File(path), requestEntity);

      //  result = clovaSpeechClient.upload(new File(path), requestEntity);

       // String str = result;

        int textIndex = result.lastIndexOf("\"text\":");
        int commaIndex = result.indexOf(",", textIndex);
        String txt = result.substring(textIndex + 8, commaIndex - 1);
        //System.out.println("msg : " +  txt);


        // result = clovaSpeechClient.url("file URL", requestEntity);
        // result = clovaSpeechClient.objectStorage("Object Storage key", requestEntity);
        //System.out.println(result);
        if(result != null)
            return ResponseEntity.ok(txt);
        return ResponseEntity.ok(result); //에러 처리 할 곳
    }

    @PostMapping("csAI")
    public ResponseEntity<?> csAI(){
        String result = null;
        String path = "C:\\Users\\SSAFY\\Desktop\\test\\1.mp3";
        result = clovaSpeechClient.upload(new File(path), requestEntity);
        // String str = result;

        int textIndex = result.lastIndexOf("\"text\":");
        int commaIndex = result.indexOf(",", textIndex);
        String txt = result.substring(textIndex + 8, commaIndex - 1);
        // result = clovaSpeechClient.url("file URL", requestEntity);
        // result = clovaSpeechClient.objectStorage("Object Storage key", requestEntity);
        //System.out.println(result);
        Map<String, Object> resultMap = new HashMap<>();
        HttpStatus status = HttpStatus.OK;
        if(result != null){
            boolean isFinish = false;
            String sessionId = "SSAFY1357";
            AIResponseDTO.Request request = AIResponseDTO.Request.builder()
                    .text(txt)
                    .isFinish(false)
                    .sessionId(sessionId)
                    .build();
            resultMap = analysisService.analysis(request);
            return new ResponseEntity<Map<String,Object>>(resultMap,status);
        }
        return ResponseEntity.ok(result); //에러 처리 할 곳
    }

    @PostMapping("csAIDB")
    public ResponseEntity<?> csAIDB(){
        String result = null;
        String path = "C:\\Users\\SSAFY\\Desktop\\test\\1.mp3";
        result = clovaSpeechClient.upload(new File(path), requestEntity);
        // String str = result;

        int textIndex = result.lastIndexOf("\"text\":");
        int commaIndex = result.indexOf(",", textIndex);
        String txt = result.substring(textIndex + 8, commaIndex - 1);
        // result = clovaSpeechClient.url("file URL", requestEntity);
        // result = clovaSpeechClient.objectStorage("Object Storage key", requestEntity);
        //System.out.println(result);
        Map<String, Object> resultMap = new HashMap<>();
        HttpStatus status = HttpStatus.OK;
        if(result != null){
            boolean isFinish = false;
            String sessionId = "SSAFY1357";
            AIResponseDTO.Request request = AIResponseDTO.Request.builder()
                    .text(txt)
                    .isFinish(false)
                    .sessionId(sessionId)
                    .build();
            resultMap = analysisService.analysis(request);
            return new ResponseEntity<Map<String,Object>>(resultMap,status);
        }
        return ResponseEntity.ok(result); //에러 처리 할 곳
    }



    @PostMapping("/colva")
    public ResponseEntity<?> clova(){
        String text = "test";//analysisService.SpeechToText();
        return ResponseEntity.ok("File uploaded");
    }

    @PostMapping("/colvaAI")
    public ResponseEntity<?> clovaAI(){

        String text = "test";//analysisService.SpeechToText();
        boolean isFinish = false;
        String sessionId = "SSAFY1357";
        AIResponseDTO.Request request = AIResponseDTO.Request.builder()
                .text(text)
                .isFinish(false)
                .sessionId(sessionId)
                .build();

        HttpStatus status = HttpStatus.OK;
        Map<String, Object> resultMap = new HashMap<>();

       resultMap = analysisService.analysis(request);
        //Object obj = resultMap.get("result");
       return new ResponseEntity<Map<String,Object>>(resultMap,status);
    }

    @PostMapping("/colvaAIfront")
    public ResponseEntity<?> clovaAIfront(){
        Map<String, Object> resultMap = new HashMap<>();
        HttpStatus status = HttpStatus.OK;
        ResponseEntity<?> re = clovaAI();

        return re;
    }

    @PostMapping("/db")
    public ResponseEntity<?> DB(){

        String text = analysisService.SpeechToText("a","b");
        boolean isFinish = false;
        String sessionId = "SSAFY1357";
        AIResponseDTO.Request request = AIResponseDTO.Request.builder()
                .text(text)
                .isFinish(false)
                .sessionId(sessionId)
                .build();

        HttpStatus status = HttpStatus.OK;
        Map<String, Object> resultMap = new HashMap<>();

        resultMap = analysisService.analysis(request);
        Object obj = resultMap.get("result");
        AIResponseDTO.Response rep = (AIResponseDTO.Response) resultMap.get("result");
        String phoneNumber = "010-1234-5678";
        String androidId = "android1";
        ResultDTO.Result res = ResultDTO.Result.builder()
                .androidId(androidId)
                .phoneNumber(phoneNumber)
                .category(rep.getTotalCategory())
                .risk((int)rep.getTotalCategoryScore())
                .build();

        Boolean b = resultService.addResult(res);
        System.out.println(b);


        return new ResponseEntity<Map<String,Object>>(resultMap,status);
    }



    @PostMapping("/AI")
    public ResponseEntity<?> getAI(@RequestBody AIResponseDTO.Request rb){
        HttpStatus status = HttpStatus.OK;
        Map<String, Object> resultMap = new HashMap<>();
        resultMap = analysisService.analysis(rb);

        return new ResponseEntity<Map<String,Object>>(resultMap,status);
    }

    @PostMapping("/result")
    public ResponseEntity<?> getResult(@RequestBody AIResponseDTO.Request rb){
        HttpStatus status = HttpStatus.OK;
        Map<String, Object> resultMap = new HashMap<>();

        resultMap = analysisService.getResult(rb);

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
        //String text = analysisService.SpeechToText();
        String text = analysisService.FileSpeechToText(file);
        System.out.println("after file speech");
        boolean isFinish = false;
        String sessionId = "SSAFY1357";
        AIResponseDTO.Request request = AIResponseDTO.Request.builder()
                .text(text)
                .isFinish(false)
                .sessionId(sessionId)
                .build();

        HttpStatus status = HttpStatus.OK;
        Map<String, Object> resultMap = new HashMap<>();

        resultMap = analysisService.analysis(request);

        System.out.println(resultMap.get("result"));
        return new ResponseEntity<Map<String,Object>>(resultMap,status);


    }
    @PostMapping("/reqfile")
    public ResponseEntity<?> reqFile(String sessionId, String filepath, boolean isFinish){
        String result = null;
        //result = "{\"result\":\"COMPLETED\",\"message\":\"Succeeded\",\"token\":\"e60bc43831984c9394038a1ec58b8585\",\"version\":\"ncp_v2_v2.1.6-d90fef3-20230420_v1.5.9_v4.1.5_ko_ncp_20221227_\",\"params\":{\"service\":\"ncp\",\"domain\":\"general\",\"lang\":\"ko\",\"completion\":\"sync\",\"diarization\":{\"enable\":true,\"speakerCountMin\":-1,\"speakerCountMax\":-1},\"boostings\":[],\"forbiddens\":\"\",\"wordAlignment\":true,\"fullText\":true,\"noiseFiltering\":true,\"resultToObs\":false,\"priority\":0,\"userdata\":{\"_ncp_DomainCode\":\"voicePassing\",\"_ncp_DomainId\":5107,\"_ncp_TaskId\":12819511,\"_ncp_TraceId\":\"11478a90a75c421ca766d1fd31d17ad6\"}},\"progress\":100,\"keywords\":{},\"segments\":[{\"start\":10080,\"end\":15020,\"text\":\"수고하십니다. 여기 서울지검 첨단범죄수사팀의 김민재 수사관이라고 합니다.\",\"confidence\":0.92385113,\"diarization\":{\"label\":\"1\"},\"speaker\":{\"label\":\"1\",\"name\":\"A\",\"edited\":false},\"words\":[[10450,11040,\"수고하십니다.\"],[11650,11880,\"여기\"],[11880,12400,\"서울지검\"],[12450,13520,\"첨단범죄수사팀의\"],[13520,13920,\"김민재\"],[13920,14380,\"수사관이라고\"],[14380,14680,\"합니다.\"]],\"textEdited\":\"수고하십니다. 여기 서울지검 첨단범죄수사팀의 김민재 수사관이라고 합니다.\"}],\"text\":\"수고하십니다. 여기 서울지검 첨단범죄수사팀의 김민재 수사관이라고 합니다.\",\"confidence\":0.9238512,\"speakers\":[{\"label\":\"1\",\"name\":\"A\",\"edited\":false}]}";
        result = clovaSpeechClient.upload(new File(filepath), requestEntity);
        System.out.println(result);
        int textIndex = result.lastIndexOf("\"text\":");
        int commaIndex = result.indexOf(",", textIndex);
        String txt = result.substring(textIndex + 8, commaIndex - 1);
        
        Map<String, Object> resultMap = new HashMap<>();
        HttpStatus status = HttpStatus.OK;
        if(result != null){
            AIResponseDTO.Request request = AIResponseDTO.Request.builder()
                    .text(txt)
                    .isFinish(isFinish)
                    .sessionId(sessionId)
                    .build();
            resultMap = analysisService.analysis(request);
            return new ResponseEntity<Map<String,Object>>(resultMap,status);
        }
        return ResponseEntity.ok(result); //에러 처리 할 곳
    }
}
