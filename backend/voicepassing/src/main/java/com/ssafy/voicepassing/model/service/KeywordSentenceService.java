package com.ssafy.voicepassing.model.service;

import com.ssafy.voicepassing.model.dto.KeywordDTO;
import com.ssafy.voicepassing.model.dto.KeywordSentenceDTO;
import com.ssafy.voicepassing.model.entity.KeywordSentence;

public interface KeywordSentenceService {
    public boolean addKeywordSentence(KeywordSentenceDTO.KeywordSentence ksDTO);
    public KeywordSentence addKeywordSentenceReturn(KeywordSentenceDTO.KeywordSentence ksDTO);
    public KeywordSentenceDTO.KeywordSentence getKeywordSentence(String keyword);
}
