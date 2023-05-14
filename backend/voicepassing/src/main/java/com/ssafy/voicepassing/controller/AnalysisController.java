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
        System.out.println("an : " + androidId);
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
            boolean re = saveDB(resultMap,androidId);
            if(re)
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

//    @PostMapping("cs")
//    public ResponseEntity<?> cs(){
//        String result = null;
//        String path = "C:\\Users\\SSAFY\\Desktop\\test\\1.mp3";
//        result = clovaSpeechClient.upload(new File(path), requestEntity);
//
//        //  result = clovaSpeechClient.upload(new File(path), requestEntity);
//
//        // String str = result;
//
//        int textIndex = result.lastIndexOf("\"text\":");
//        int commaIndex = result.indexOf(",", textIndex);
//        String txt = result.substring(textIndex + 8, commaIndex - 1);
//        //System.out.println("msg : " +  txt);
//
//
//        // result = clovaSpeechClient.url("file URL", requestEntity);
//        // result = clovaSpeechClient.objectStorage("Object Storage key", requestEntity);
//        //System.out.println(result);
//        if(result != null)
//            return ResponseEntity.ok(result);
//        return ResponseEntity.ok(result); //에러 처리 할 곳
//    }
//
//    @PostMapping("/csAI")
//    public ResponseEntity<?> csAI(){
//        System.out.println("in");
//        String result = null;
//        String path = "C:\\Users\\SSAFY\\Desktop\\test\\1.mp3";
//        result = clovaSpeechClient.upload(new File(path), requestEntity);
//        // String str = result;
//        int textIndex = result.lastIndexOf("\"text\":");
//        int commaIndex = result.indexOf(",", textIndex);
//        String txt = result.substring(textIndex + 8, commaIndex - 1);
//        System.out.println(txt);
//        // result = clovaSpeechClient.url("file URL", requestEntity);
//        // result = clovaSpeechClient.objectStorage("Object Storage key", requestEntity);
//        //System.out.println(result);
//        Map<String, Object> resultMap = new HashMap<>();
//        HttpStatus status = HttpStatus.OK;
//        if(result != null){
//            boolean isFinish = false;
//            String sessionId = "SSAFY1357";
//            AIResponseDTO.Request request = AIResponseDTO.Request.builder()
//                    .text(txt)
//                    .isFinish(false)
//                    .sessionId(sessionId)
//                    .build();
//            resultMap = analysisService.analysis(request);
//            return new ResponseEntity<Map<String,Object>>(resultMap,status);
//        }
//        return ResponseEntity.ok(result); //에러 처리 할 곳
//    }
//
//    //업로드 파일 분석
//
//
//
//    @PostMapping("csAIDB")
//    public ResponseEntity<?> csAIDB(){
//        String result = null;
//        String path = "C:\\Users\\SSAFY\\Desktop\\test\\1.mp3";
//        result = clovaSpeechClient.upload(new File(path), requestEntity);
//        // String str = result;
//        System.out.println(result);
//        int textIndex = result.lastIndexOf("\"text\":");
//        int commaIndex = result.indexOf(",", textIndex);
//        String txt = result.substring(textIndex + 8, commaIndex - 1);
//        // result = clovaSpeechClient.url("file URL", requestEntity);
//        // result = clovaSpeechClient.objectStorage("Object Storage key", requestEntity);
//        //System.out.println(result);
//        Map<String, Object> resultMap = new HashMap<>();
//        HttpStatus status = HttpStatus.OK;
//        if(result != null){
//            boolean isFinish = true;
//            String sessionId = "SSAFY1357";
//            AIResponseDTO.Request request = AIResponseDTO.Request.builder()
//                    .text(txt)
//                    .isFinish(false)
//                    .sessionId(sessionId)
//                    .build();
//            resultMap = analysisService.analysis(request);
//            //result
//            if(isFinish){
//
//                //result 추가
//                AIResponseDTO.Response rep = (AIResponseDTO.Response) resultMap.get("result");
//                String phoneNumber = "010-1234-1111";
//                String androidId = "android2";
//                ResultDTO.Result res = ResultDTO.Result.builder()
//                        .androidId(androidId)
//                        .phoneNumber(phoneNumber)
//                        .category(rep.getTotalCategory())
//                        .risk(rep.getTotalCategoryScore())
//                        .build();
//
//                int rId = resultService.addResult(res);
//                System.out.println(rId);
//
//
//
//                //keyword 추가
//                AIResponseDTO.Response response = (AIResponseDTO.Response)resultMap.get("result");
//                List<AIResponseDTO.Result> resultList = response.getResults();
//
//                for (AIResponseDTO.Result r : resultList) {
//                    KeywordDTO.Keyword keywordDTO = KeywordDTO.Keyword.builder()
//                            .keyword(r.getSentKeyword())
//                            .category(r.getSentCategory())
//                            .count(0)
//                            .build();
//
//                    Boolean k = keywordService.addKeyword(keywordDTO);
//                }
//
//                for (AIResponseDTO.Result r : resultList) {
//                    KeywordSentenceDTO.KeywordSentence ksDTO = KeywordSentenceDTO.KeywordSentence
//                            .builder()
//                            .score(r.getKeywordScore())
//                            .keyword(r.getSentKeyword())
//                            .sentence(r.getSentence())
//                            .build();
//                    Boolean ksb = keywordSentenceService.addKeywordSentence(ksDTO);
//                }
//
//                for (AIResponseDTO.Result r : resultList) {
//                    ResultDetailDTO.ResultDetail rdDTO = ResultDetailDTO.ResultDetail.
//                            builder()
//                            .resultId(rId)
//                            .sentence(r.getSentence())
//                            .build();
//
//                    int rgd = resultDetailService.addResultDetail(rdDTO);
//                }
//
//
//
//                resultMap.put("key", response.getResults());
//
//
//            }
//
//            return new ResponseEntity<Map<String,Object>>(resultMap,status);
//        }
//        return ResponseEntity.ok(result); //에러 처리 할 곳
//    }
//
//
//
//    @PostMapping("/colva")
//    public ResponseEntity<?> clova(){
//        String text = "test";//analysisService.SpeechToText();
//        return ResponseEntity.ok("File uploaded");
//    }
//
//    @PostMapping("/colvaAI")
//    public ResponseEntity<?> clovaAI(){
//
//        String text = "test";//analysisService.SpeechToText();
//        boolean isFinish = false;
//        String sessionId = "SSAFY1357";
//        AIResponseDTO.Request request = AIResponseDTO.Request.builder()
//                .text(text)
//                .isFinish(false)
//                .sessionId(sessionId)
//                .build();
//
//        HttpStatus status = HttpStatus.OK;
//        Map<String, Object> resultMap = new HashMap<>();
//
//       resultMap = analysisService.analysis(request);
//        //Object obj = resultMap.get("result");
//       return new ResponseEntity<Map<String,Object>>(resultMap,status);
//    }
//
//
//
//    @PostMapping("/colvaAIfront")
//    public ResponseEntity<?> clovaAIfront(){
//        Map<String, Object> resultMap = new HashMap<>();
//        HttpStatus status = HttpStatus.OK;
//        ResponseEntity<?> re = clovaAI();
//
//        return re;
//    }
//
//    @PostMapping("/db")
//    public ResponseEntity<?> DB(){
//
//        String text = analysisService.SpeechToText("a","b");
//        boolean isFinish = false;
//        String sessionId = "SSAFY1357";
//        AIResponseDTO.Request request = AIResponseDTO.Request.builder()
//                .text(text)
//                .isFinish(false)
//                .sessionId(sessionId)
//                .build();
//
//        HttpStatus status = HttpStatus.OK;
//        Map<String, Object> resultMap = new HashMap<>();
//
//        resultMap = analysisService.analysis(request);
//        Object obj = resultMap.get("result");
//        AIResponseDTO.Response rep = (AIResponseDTO.Response) resultMap.get("result");
//        String phoneNumber = "010-1234-5678";
//        String androidId = "android1";
//        ResultDTO.Result res = ResultDTO.Result.builder()
//                .androidId(androidId)
//                .phoneNumber(phoneNumber)
//                .category(rep.getTotalCategory())
//                .risk((int)rep.getTotalCategoryScore())
//                .build();
//
//        int b = resultService.addResult(res);
//        System.out.println(b);
//
//
//        return new ResponseEntity<Map<String,Object>>(resultMap,status);
//    }
//
//
//
//    @PostMapping("/AI")
//    public ResponseEntity<?> getAI(@RequestBody AIResponseDTO.Request rb){
//        HttpStatus status = HttpStatus.OK;
//        Map<String, Object> resultMap = new HashMap<>();
//        resultMap = analysisService.analysis(rb);
//
//        return new ResponseEntity<Map<String,Object>>(resultMap,status);
//    }



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
//    	AIResponseDTO.Request request = AIResponseDTO.Request.builder()
//                .text("네 다름이 아니고 본인과 관련된 명의도용 사건 때문에 네 가지 사실 확인차 연락을 드렸습니다.")
//                .isFinish(true)
//                .sessionId("temp")
//                .build();
//		Map<String, Object> myResult = analysisService.analysis(request);
//		System.out.println("테스트 : " + myResult);
//		
//		Gson gson = new Gson();
//		String json = gson.toJson(myResult);
//		AIResponseDTO.Response aiDTO = gson.fromJson(gson.toJson(myResult.get("result")),AIResponseDTO.Response.class);
//		dataInput(aiDTO,"01012341234","dump");
		File file = new File(RECORD_PATH+"/text.txt");
		int cnt = 0;
        try {
            try (BufferedReader br = new BufferedReader(new FileReader(file))) {
                String line;
                
                while ((line = br.readLine()) != null) {
                	System.out.println(line + " " + (cnt%4==3));
                	AIResponseDTO.Request request = AIResponseDTO.Request.builder()
                            .text("명사 " + line)
                            .isFinish(cnt%15==14)
                            .sessionId("temp"+(cnt/15))
                            .build();
            		Map<String, Object> myResult = analysisService.analysis(request);
            		System.out.println("테스트 : " + myResult);
            		
            		Gson gson = new Gson();
            		String json = gson.toJson(myResult);
            		AIResponseDTO.Response aiDTO = gson.fromJson(gson.toJson(myResult.get("result")),AIResponseDTO.Response.class);
            		System.out.println(aiDTO);
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
		System.out.println("데이터베이스에 작업 시작");
        ResultDTO.Result res = ResultDTO.Result.builder()
                .androidId(androidId)
                .phoneNumber(phoneNumber)
                .category(rep.getTotalCategory())
                .risk(rep.getTotalCategoryScore())
                .build();

        int rId = resultService.addResult(res);
        System.out.println(rId);


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
