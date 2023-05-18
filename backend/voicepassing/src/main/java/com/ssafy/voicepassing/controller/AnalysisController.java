package com.ssafy.voicepassing.controller;


import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.ssafy.voicepassing.model.dto.*;
import com.ssafy.voicepassing.model.entity.Keyword;
import com.ssafy.voicepassing.model.entity.KeywordSentence;
import com.ssafy.voicepassing.model.entity.ResultDetail;
import com.ssafy.voicepassing.model.service.*;
import com.ssafy.voicepassing.util.RestAPIUtil;

import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.http.*;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.socket.TextMessage;

import java.io.File;
import java.io.IOException;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@RestController
@RequestMapping("/api/analysis")
@Tag(name="[Analysis] analysis API")
@Slf4j
@RequiredArgsConstructor
public class AnalysisController {

    private static final Logger logger = LoggerFactory.getLogger(AnalysisController.class);
    
    @Value("${SPRING_RECORD_TEMP_DIR}")
	private String RECORD_PATH;
    
    private final ResultService resultService;

    private final AnalysisService analysisService;

    private final KeywordService keywordService;

    private final KeywordSentenceService keywordSentenceService;

    private final ResultDetailService resultDetailService;

    @Autowired
    private ClovaSpeechService clovaSpeechClient;
    
    ClovaSpeechService.NestRequestEntity requestEntity = new ClovaSpeechService.NestRequestEntity();

    @PostMapping("/file")
    public ResponseEntity<?> handleFileUpload(@RequestParam("file") MultipartFile file,
                                              @RequestParam("androidId") String androidId
                                              ) throws IOException {

        String result = null;
        byte[] bytes = file.getBytes();
        File newFile = new File(file.getOriginalFilename());
        Files.write(newFile.toPath(), bytes);

        result = clovaSpeechClient.upload(newFile, requestEntity);
        int textIndex = result.lastIndexOf("\"text\":");
        int commaIndex = result.indexOf(",", textIndex);
        String txt = result.substring(textIndex + 8, commaIndex - 1);
        Map<String, Object> resultMap = new HashMap<>();
        HttpStatus status = HttpStatus.ACCEPTED; //202
        if(result != null){
            AIResponseDTO.Request request = AIResponseDTO.Request.builder()
                    .text(txt)
                .isFinish(true)
                .sessionId(androidId)
                .build();
            resultMap = analysisService.analysis(request);
            if(newFile.exists()){
                newFile.delete();
            }

            status = (HttpStatus) resultMap.get("status");
            if(status == HttpStatus.CREATED)
                return new ResponseEntity<Map<String,Object>>(resultMap,status);
            else if(status == HttpStatus.OK)
                saveDB(resultMap,androidId);

            return new ResponseEntity<Map<String,Object>>(resultMap,status);
        }
        return (ResponseEntity<?>) ResponseEntity.notFound();

    }

    public boolean saveDB(Map<String,Object> resultMap,String androidId){
        Boolean k = false,ksb = false;



        //result 추가
        AIResponseDTO.Response rep = (AIResponseDTO.Response) resultMap.get("result");
        String phoneNumber = "unknown";
        ResultDTO.Result res = ResultDTO.Result.builder()
                .androidId(androidId)
                .phoneNumber(phoneNumber)
                .category(rep.getTotalCategory())
                .risk(rep.getTotalCategoryScore())
                .build();

        int rId = resultService.addResult(res);

        //keyword 추가
        AIResponseDTO.Response response = (AIResponseDTO.Response)resultMap.get("result");
        List<AIResponseDTO.Result> resultList = response.getResults();

        for (AIResponseDTO.Result r : resultList) {
            KeywordDTO.Keyword keywordDTO = KeywordDTO.Keyword.builder()
                    .keyword(r.getSentKeyword())
                    .category(r.getSentCategory())
                    .count(0)
                    .build();

            k = keywordService.addKeyword(keywordDTO);
        }

        for (AIResponseDTO.Result r : resultList) {
            KeywordSentenceDTO.KeywordSentence ksDTO = KeywordSentenceDTO.KeywordSentence
                    .builder()
                    .score(r.getKeywordScore())
                    .keyword(r.getSentKeyword())
                    .sentence(r.getSentence())
                    .build();
            ksb = keywordSentenceService.addKeywordSentence(ksDTO);
        }

        for (AIResponseDTO.Result r : resultList) {
            ResultDetailDTO.ResultDetail rdDTO = ResultDetailDTO.ResultDetail.
                    builder()
                    .resultId(rId)
                    .sentence(r.getSentence())
                    .build();

            int rgd = resultDetailService.addResultDetail(rdDTO);
        }
        return  k && ksb;
    }




    @PostMapping("/file2text")
    public ResponseEntity<?> fileToText(String sessionId, String filepath, boolean isFinish){
        String result = null;

        result = clovaSpeechClient.upload(new File(filepath), requestEntity);
        int textIndex = result.lastIndexOf("\"text\":");
        int commaIndex = result.indexOf(",", textIndex);
        String txt = result.substring(textIndex + 8, commaIndex - 1);
        logger.info("클로바 텍스트 변환 결과 : {}", txt);
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
    
    @GetMapping("/directAI")
    public ResponseEntity<?> directAI() throws Exception{

		File file = new File(RECORD_PATH+"/text.txt");
		int cnt = 0;
        try {
            try (BufferedReader br = new BufferedReader(new FileReader(file))) {
                String line;
                
                while ((line = br.readLine()) != null) {
                	AIResponseDTO.Request request = AIResponseDTO.Request.builder()
                            .text("명사 " + line)
                            .isFinish(cnt%15==14)
                            .sessionId("temp"+(cnt/15))
                            .build();
            		Map<String, Object> myResult = analysisService.analysis(request);

            		
            		Gson gson = new Gson();
            		String json = gson.toJson(myResult);
            		AIResponseDTO.Response aiDTO = gson.fromJson(gson.toJson(myResult.get("result")),AIResponseDTO.Response.class);

            		if(cnt%4==3 && aiDTO.getTotalCategory()!=0) {
            			dataInput(aiDTO,"0101111"+String.format("%04d",(cnt/15)),"temp"+(cnt/15));
            		}
            		
                 	
            		cnt++;
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
		return new ResponseEntity<String>("finish",HttpStatus.OK); //에러 처리 할 곳
    }
    
    public void dataInput(AIResponseDTO.Response rep,String phoneNumber,String androidId) {
        ResultDTO.Result res = ResultDTO.Result.builder()
                .androidId(androidId)
                .phoneNumber(phoneNumber)
                .category(rep.getTotalCategory())
                .risk(rep.getTotalCategoryScore())
                .build();

        int rId = resultService.addResult(res);



        List<AIResponseDTO.Result> resultList = rep.getResults();

        for (AIResponseDTO.Result r : resultList) {
        	KeywordDTO.Keyword keywordDTO = KeywordDTO.Keyword.builder()
                    .keyword(r.getSentKeyword())
                    .category(r.getSentCategory())
                    .count(0)
                    .build();

            Keyword k = keywordService.addKeywordReturn(keywordDTO);
        	
            KeywordSentenceDTO.KeywordSentence ksDTO = KeywordSentenceDTO.KeywordSentence
                    .builder()
                    .score(r.getKeywordScore())
                    .keyword(k.getKeyword())
                    .sentence(r.getSentence())
                    .category(k.getCategory())
                    .build();
            KeywordSentence ksb = keywordSentenceService.addKeywordSentenceReturn(ksDTO);
            
            ResultDetailDTO.ResultDetail rdDTO = ResultDetailDTO.ResultDetail.
                    builder()
                    .resultId(rId)
                    .sentence(ksb.getSentence())
                    .build();
            int rgd = resultDetailService.addResultDetail(rdDTO);
        }

    
	}
}
