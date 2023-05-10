package com.ssafy.voicepassing.model.service;

import com.ssafy.voicepassing.model.dto.KeywordDTO;
import com.ssafy.voicepassing.model.entity.Keyword;
import com.ssafy.voicepassing.model.repository.KeywordRepository;
import com.ssafy.voicepassing.model.repository.ResultRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
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
    public List<KeywordDTO.PopularKeyword> getPopularKeyword() {
        List<Keyword> keywordList = keywordRepository.findAllByOrderByCountDesc();
        List<KeywordDTO.PopularKeyword> resultList = new ArrayList<>();
        for (int i = 0;i < 3;i ++) {
            if (keywordList.size() > i) {
                String keyword = keywordList.get(i).getKeyword();
                resultList.add(
                        KeywordDTO.PopularKeyword.builder()
                                .keyword(keyword).build()
                );
            }
        }
        return resultList;
    }
}
