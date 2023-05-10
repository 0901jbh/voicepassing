package com.ssafy.voicepassing.controller;

import com.ssafy.voicepassing.model.dto.KeywordDTO;
import com.ssafy.voicepassing.model.dto.KeywordSentenceDTO;
import com.ssafy.voicepassing.model.service.KeywordService;
import com.ssafy.voicepassing.model.service.KeywordSentenceService;
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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@RestController
@RequestMapping("/api/keyword")
@Tag(name="[Keyword] Keyword API")
@Slf4j
@RequiredArgsConstructor
public class KeywordController {
    private static final Logger logger = LoggerFactory.getLogger(KeywordController.class);
    private final KeywordService keywordService;
    private final KeywordSentenceService keywordSentenceService;

    @GetMapping()
    public ResponseEntity<?> getPopularKeyword() {
        HttpStatus status;
        Map<String, List<KeywordSentenceDTO.KeywordSentence>> resultMap = new HashMap<>();
        List<KeywordDTO.PopularKeyword> keywordList = keywordService.getPopularKeyword();
        List<KeywordSentenceDTO.KeywordSentence> resultList = new ArrayList<>();

        for (KeywordDTO.PopularKeyword keyword : keywordList) {
            KeywordSentenceDTO.KeywordSentence keywordSentence = keywordSentenceService.getKeywordSentence(keyword.getKeyword());
            resultList.add(keywordSentence);
        }
        status = HttpStatus.OK;
        resultMap.put("keywords", resultList);
        return new ResponseEntity<Map<String, List<KeywordSentenceDTO.KeywordSentence>>>(resultMap, status);
    }
}
