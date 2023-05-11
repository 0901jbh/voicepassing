package com.ssafy.voicepassing.model.service;

import com.ssafy.voicepassing.model.dto.KeywordDTO;
import com.ssafy.voicepassing.model.entity.Keyword;
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
        if(keywordRepository.existsById(keyword.getKeyword())) {
            Keyword k = keywordRepository.findById(keyword.getKeyword()).get();

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
    public List<List<Keyword>> getPopularKeyword() {
        List<Keyword> keyword1List = keywordRepository.findTop3ByCategoryOrderByCountDesc(1);
        List<Keyword> keyword2List = keywordRepository.findTop3ByCategoryOrderByCountDesc(2);
        List<Keyword> keyword3List = keywordRepository.findTop3ByCategoryOrderByCountDesc(3);
        ArrayList<List<Keyword>> resultList = new ArrayList<>(Arrays.asList(keyword1List, keyword2List, keyword3List));
        return resultList;
    }
}
