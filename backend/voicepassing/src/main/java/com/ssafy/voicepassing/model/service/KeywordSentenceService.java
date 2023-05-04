package com.ssafy.voicepassing.model.service;

import com.ssafy.voicepassing.model.dto.KeywordDTO;
import com.ssafy.voicepassing.model.dto.KeywordSentenceDTO;

public interface KeywordSentenceService {
    public boolean addKeywordSentence(KeywordSentenceDTO.KeywordSentence ksDTO);
}
