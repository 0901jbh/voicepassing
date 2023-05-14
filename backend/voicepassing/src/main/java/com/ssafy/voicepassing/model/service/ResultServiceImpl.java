package com.ssafy.voicepassing.model.service;


import com.ssafy.voicepassing.model.dto.ResultDTO;
import com.ssafy.voicepassing.model.entity.KeywordSentence;
import com.ssafy.voicepassing.model.entity.Result;
import com.ssafy.voicepassing.model.entity.ResultDetail;
import com.ssafy.voicepassing.model.repository.KeywordSentenceRepository;
import com.ssafy.voicepassing.model.repository.ResultDetailRepository;
import com.ssafy.voicepassing.model.repository.ResultRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.PersistenceException;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;


@Service
@RequiredArgsConstructor
public class ResultServiceImpl implements ResultService {

    private final ResultRepository resultRepository;
    private final ResultDetailRepository resultDetailRepository;
    private final KeywordSentenceRepository keywordSentenceRepository;


    @Override
    public List<ResultDTO.Result> getResultList(String androidId) {
        List<Result> resultsEntity = resultRepository.findAllByAndroidId(androidId);
        List<ResultDTO.Result> resultList = new ArrayList<>();
        for (Result result: resultsEntity) {
            ResultDTO.Result resultDto = buildResult(result);
            resultList.add(ResultDTO.Result.builder()
                    .phoneNumber(result.getPhoneNumber())
                    .category(result.getCategory())
                    .createdTime(result.getCreatedTime())
                    .risk(result.getRisk())
                    .build()
                    );
        }
        return resultList;

    }

    @Override
    public int addResult(ResultDTO.Result resultDTO) {
        try{
            Result result = Result.builder()
                    .androidId(resultDTO.getAndroidId())
                    .category(resultDTO.getCategory())
                    .phoneNumber(resultDTO.getPhoneNumber())
                    .risk(resultDTO.getRisk())
                    .build();
            Result r = resultRepository.save(result);
            return r.getResultId();
        } catch (PersistenceException e) {
            return -1;
        }

    }
    
    public ResultDTO.ResultNum getResultNum() {
        long resultNum = resultRepository.count();
        return ResultDTO.ResultNum.builder().resultNum(resultNum).build();
    }

    @Override
    public List<ResultDTO.Result> searchByPhoneNumber(String phoneNumber) {
        if(phoneNumber.trim().length() < 1) {
            return null;}
        List<Result> resultsEntity = resultRepository.findAllByPhoneNumberAndCategoryNotLike(phoneNumber);
        List<ResultDTO.Result> resultList = new ArrayList<>(resultsEntity.size());
        resultsEntity.forEach(result ->{
            resultList.add(ResultDTO.Result.builder()
                    .phoneNumber(result.getPhoneNumber())
                    .category(result.getCategory())
                    .createdTime(result.getCreatedTime())
                    .build());
        });

        return resultList;
    }


    private ResultDTO.Result buildResult(Result result){
        ResultDTO.Result resultDto = ResultDTO.Result.builder()
                .resultId(result.getResultId())
                .androidId(result.getAndroidId())
                .category(result.getCategory())
                .risk(result.getRisk())
                .phoneNumber(result.getPhoneNumber())
                .build();

        return resultDto;
    }
    @Override
    public List<ResultDTO.ResultWithWords> getResults(String androidId) {
        List<Result> resultsEntity = resultRepository.findAllByAndroidId(androidId);
        List<ResultDTO.ResultWithWords> resultList = new ArrayList<>();
        for (Result result: resultsEntity) {
            ResultDTO.Result resultDto = buildResult(result);
            List<String> sentences = resultDetailRepository.findAllByResultId(resultDto.getResultId()).stream().map(ResultDetail::getSentence).collect(Collectors.toList());
            List<String> words = new ArrayList<>();
            for (String sentence: sentences) {
                String word = keywordSentenceRepository.findBySentenceStartsWith(sentence).getKeyword();
                words.add(word);
            }
            resultList.add(
                    ResultDTO.ResultWithWords.builder()
                            .keyword(words)
                            .sentence(sentences)
                            .risk(result.getRisk())
                            .category(result.getCategory())
                            .phoneNumber(result.getPhoneNumber())
                            .createdTime(result.getCreatedTime())
                            .build()
            );
        }
        return resultList;

    }

    @Override
    public ResultDTO.CategoryResultNum getCategoryResultNum() {
        LocalDateTime now = LocalDateTime.now();
        List<Result> resultEntity = resultRepository.findByCreatedTimeBetween(now.minusMonths(1), now);
        List<Integer> numList = new ArrayList<>(Arrays.asList(0, 0, 0, 0, 0));
        for (Result result: resultEntity) {
            int category = result.getCategory();

            if (category != -1) {
                numList.set(category, numList.get(category) + 1);
            }
            else {
                numList.set(4, numList.get(4) + 1);
            }
        }

        return ResultDTO.CategoryResultNum.builder().categoryList(numList).build();
    }


}
