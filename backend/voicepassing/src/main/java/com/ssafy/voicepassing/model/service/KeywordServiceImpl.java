package com.ssafy.voicepassing.model.service;

import com.ssafy.voicepassing.model.dto.KeywordDTO;
import com.ssafy.voicepassing.model.entity.Keyword;
import com.ssafy.voicepassing.model.entity.KeywordID;
import com.ssafy.voicepassing.model.repository.KeywordRepository;
import com.ssafy.voicepassing.model.repository.ResultRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class KeywordServiceImpl implements KeywordService{

    private final KeywordRepository keywordRepository;
    @Override
    public boolean addKeyword(KeywordDTO.Keyword keyword) {
        Keyword keywordEntity;
        KeywordID keywordId = new KeywordID(keyword.getKeyword(),keyword.getCategory());
        if(keywordRepository.existsById(keywordId)) {
            Keyword k = keywordRepository.findById(keywordId).get();

            keywordEntity = Keyword.builder()
                    .keyword(keyword.getKeyword())
                    .category(keyword.getCategory())
                    .count(k.getCount()+1)
                    .build();
        } else {
            System.out.println("존재하지 않아");
            keywordEntity = Keyword.builder()
                    .keyword(keyword.getKeyword())
                    .category(keyword.getCategory())
                    .count(1)
                    .build();
        }

        keywordRepository.save(keywordEntity);
        return true;
    }
    
    @Override
    public Keyword addKeywordReturn(KeywordDTO.Keyword keyword) {
        Keyword keywordEntity;
        KeywordID keywordId = new KeywordID(keyword.getKeyword(),keyword.getCategory());
        if(keywordRepository.existsById(keywordId)) {
            Keyword k = keywordRepository.findById(keywordId).get();

            keywordEntity = Keyword.builder()
                    .keyword(keyword.getKeyword())
                    .category(keyword.getCategory())
                    .count(k.getCount()+1)
                    .build();
        } else {
            System.out.println("존재하지 않아");
            keywordEntity = Keyword.builder()
                    .keyword(keyword.getKeyword())
                    .category(keyword.getCategory())
                    .count(1)
                    .build();
        }

        keywordRepository.save(keywordEntity);
        return keywordEntity;
    }
}
