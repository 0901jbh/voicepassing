package com.ssafy.voicepassing.model.service;

import com.ssafy.voicepassing.model.dto.KeywordDTO;
import com.ssafy.voicepassing.model.dto.KeywordSentenceDTO;
import com.ssafy.voicepassing.model.entity.Keyword;
import com.ssafy.voicepassing.model.entity.KeywordSentence;
import com.ssafy.voicepassing.model.repository.KeywordRepository;
import com.ssafy.voicepassing.model.repository.KeywordSentenceRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class KeywordSentenceServiceImpl implements KeywordSentenceService{

    private final KeywordSentenceRepository keywordSentenceRepository;

    @Override
    public boolean addKeywordSentence(KeywordSentenceDTO.KeywordSentence ksDTO) {
        KeywordSentence ks = KeywordSentence.builder()
                .keyword(ksDTO.getKeyword())
                .sentence(ksDTO.getSentence())
                .score(ksDTO.getScore())
                .category(ksDTO.getCategory())
                .build();
        keywordSentenceRepository.save(ks);

        return true;
    }
    
    @Override
    public KeywordSentence addKeywordSentenceReturn(KeywordSentenceDTO.KeywordSentence ksDTO) {
        KeywordSentence ks = KeywordSentence.builder()
                .keyword(ksDTO.getKeyword())
                .sentence(ksDTO.getSentence())
                .score(ksDTO.getScore())
                .category(ksDTO.getCategory())
                .build();
        keywordSentenceRepository.save(ks);

        return ks;
    }
}
