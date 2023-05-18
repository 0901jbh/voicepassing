package com.ssafy.voicepassing.model.service;

import com.ssafy.voicepassing.model.dto.KeywordDTO;
import com.ssafy.voicepassing.model.entity.Keyword;
import com.ssafy.voicepassing.model.entity.KeywordID;
import com.ssafy.voicepassing.model.repository.KeywordRepository;
import com.ssafy.voicepassing.model.repository.ResultRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

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
            keywordEntity = Keyword.builder()
                    .keyword(keyword.getKeyword())
                    .category(keyword.getCategory())
                    .count(1)
                    .build();
        }

        keywordRepository.save(keywordEntity);
        return keywordEntity;
    }

    @Override
    public List<List<Keyword>> getPopularKeyword() {
        List<Keyword> keyword1List = keywordRepository.findTop3ByCategoryOrderByCountDesc(1);
        List<Keyword> keyword2List = keywordRepository.findTop3ByCategoryOrderByCountDesc(2);
        List<Keyword> keyword3List = keywordRepository.findTop3ByCategoryOrderByCountDesc(3);
        ArrayList<List<Keyword>> resultList = new ArrayList<>(Arrays.asList(keyword1List, keyword2List, keyword3List));
        return resultList;
    }
}
