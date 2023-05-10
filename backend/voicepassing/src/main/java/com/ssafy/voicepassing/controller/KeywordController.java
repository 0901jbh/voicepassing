package com.ssafy.voicepassing.controller;

import com.ssafy.voicepassing.model.dto.KeywordDTO;
import com.ssafy.voicepassing.model.dto.KeywordSentenceDTO;
import com.ssafy.voicepassing.model.entity.Keyword;
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
        Map<Integer, List<KeywordSentenceDTO.KeywordSentence>> resultMap = new HashMap<>();
        List<List<Keyword>> keywordList = keywordService.getPopularKeyword();
        for (int i=0; i < 2; i++) {
            List<KeywordSentenceDTO.KeywordSentence> resultList = new ArrayList<>();

            for (Keyword keyword : keywordList.get(i)) {
                KeywordSentenceDTO.KeywordSentence keywordSentence = keywordSentenceService.getKeywordSentence(keyword.getKeyword());
                resultList.add(keywordSentence);
            }

            resultMap.put(i, resultList);

        }
        status = HttpStatus.OK;
        return new ResponseEntity<Map<Integer, List<KeywordSentenceDTO.KeywordSentence>>>(resultMap, status);
    }
}
