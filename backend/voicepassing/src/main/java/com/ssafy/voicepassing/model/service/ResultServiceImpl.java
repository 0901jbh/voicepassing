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

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
@Service
@RequiredArgsConstructor
public class ResultServiceImpl implements ResultService {

    private final ResultRepository resultRepository;
    private final ResultDetailRepository resultDetailRepository;
    private final KeywordSentenceRepository keywordSentenceRepository;

    @PersistenceContext
    private EntityManager entityManager;

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
        List<Result> resultsEntity = resultRepository.findAllByPhoneNumberAndCategoryNotLike(phoneNumber,0);
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
                //String word = keywordSentenceRepository.findBySentenceStartsWith(sentence).getKeyword();
                String word = keywordSentenceRepository.findById(sentence).get().getKeyword();
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
    public ResultDTO.ResultCount getCountByCategory() {
        LocalDateTime startDate = LocalDateTime.now().minus(1, ChronoUnit.MONTHS);
        List<Object[]> results = resultRepository.countByCategoryAndCreatedTimeAfter(startDate);
        ResultDTO.ResultCount rc = ResultDTO.ResultCount.builder()
                .category(new ArrayList<>())
                .count(new ArrayList<>())
                .build();

        for (Object[] result : results) {
            Long count = (Long) result[0];
            int category = (int) result[1];
            rc.getCategory().add(category);
            rc.getCount().add(count);
            System.out.println(category + ": " + count);
        }
        return rc;
    }


}
