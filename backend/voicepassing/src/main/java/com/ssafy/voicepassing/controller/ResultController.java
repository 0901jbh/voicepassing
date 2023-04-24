package com.ssafy.voicepassing.controller;


import com.ssafy.voicepassing.model.dto.ResultDto;
import com.ssafy.voicepassing.model.service.ResultService;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

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
//
//    //검사 결과 목록 조회
    @GetMapping()
    public ResponseEntity<?> getResults() {
        HttpStatus status = null;
        Map<String, Object> resultMap = new HashMap<>();
        List<ResultDto.Result> results = resultService.getResultList();
        if(results == null)
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
      resultMap.put("results",results);
      status = HttpStatus.OK;
       return new ResponseEntity<Map<String, Object>>(resultMap, status);

    }

}
