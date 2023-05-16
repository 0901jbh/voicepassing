package com.ssafy.voicepassing.controller;

import com.ssafy.voicepassing.model.dto.ResultDTO;
import com.ssafy.voicepassing.model.service.ResultService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/phishings")
@Slf4j
@RequiredArgsConstructor
public class PhishingsController {
    private static final Logger logger = LoggerFactory.getLogger(PhishingsController.class);
    private final ResultService resultService;
    @GetMapping("/{phoneNumber}")
    public ResponseEntity<?> searchPhoneNumber(@PathVariable String phoneNumber) {
        HttpStatus status;
        Map<String, Object> resultMap = new HashMap<>();
        //phonenumber - 파싱
        phoneNumber = phoneNumber.replaceAll("[\\-_]", "");
        System.out.println(phoneNumber);
        logger.trace("search phoneNumber by: {}", phoneNumber);
        List<ResultDTO.Result> resultList = resultService.searchByPhoneNumber(phoneNumber);
        if(resultList == null) return new ResponseEntity<Void>(HttpStatus.BAD_REQUEST);
        if(resultList.size() == 0) return new ResponseEntity<Void>(HttpStatus.NO_CONTENT);

        resultMap.put("resultList", resultList);
        status = HttpStatus.OK;
        return new ResponseEntity<Map<String, Object>>(resultMap, status);
    }

}
