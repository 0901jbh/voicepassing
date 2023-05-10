package com.ssafy.voicepassing.controller;


import com.ssafy.voicepassing.model.dto.ResultDTO;
import com.ssafy.voicepassing.model.service.ResultService;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;



@RestController
@RequestMapping("/api/results")
@Tag(name="[Result] Result API")
@Slf4j
@RequiredArgsConstructor
public class ResultController {

    private static final Logger logger = LoggerFactory.getLogger(ResultController.class);
    private final ResultService resultService;

    //검사 결과 목록 조회
    @GetMapping("/{androidId}")
    public ResponseEntity<?> getResultbyId(@PathVariable String androidId) {
        HttpStatus status = null;
//        System.out.println(androidId);
        Map<String, Object> resultMap = new HashMap<>();
        List<ResultDTO.ResultWithWords> results = resultService.getResults(androidId);

        if(results == null)
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
      resultMap.put("results",results);
      status = HttpStatus.OK;
       return new ResponseEntity<Map<String, Object>>(resultMap, status);
    }

    @GetMapping("/category")
    public ResponseEntity<?> getCategoryResults() {
        HttpStatus status;
        Map<String, List<Integer>> resultMap = new HashMap<>();
        ResultDTO.CategoryResultNum results = resultService.getCategoryResultNum();
        resultMap.put("categoryNum", results.getCategoryList());
        status = HttpStatus.OK;
        return new ResponseEntity<Map<String, List<Integer>>>(resultMap, status);
    }

    @GetMapping()
    public ResponseEntity<?> getResults() {
        HttpStatus status;
        Map<String, Long> resultMap = new HashMap<>();
        ResultDTO.ResultNum resultNum = resultService.getResultNum();
        resultMap.put("resultNum",resultNum.getResultNum());
        status = HttpStatus.OK;
        return new ResponseEntity<Map<String, Long>>(resultMap,status);
    }

}
