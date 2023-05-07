package com.ssafy.voicepassing.model.service;


import com.ssafy.voicepassing.model.dto.ResultDTO;
import com.ssafy.voicepassing.model.entity.Result;
import com.ssafy.voicepassing.model.repository.ResultRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import javax.persistence.PersistenceException;
import java.util.ArrayList;
import java.util.List;


@Service
@RequiredArgsConstructor
public class ResultServiceImpl implements ResultService {

    private final ResultRepository resultRepository;

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
    public boolean addResult(ResultDTO.Result resultDTO) {
        try{
            Result result = Result.builder()
                    .androidId(resultDTO.getAndroidId())
                    .category(resultDTO.getCategory())
                    .phoneNumber(resultDTO.getPhoneNumber())
                    .risk(resultDTO.getRisk())
                    .build();
            resultRepository.save(result);
            return true;
        } catch (PersistenceException e) {
            return false;
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
        List<Result> resultsEntity = resultRepository.findAllByPhoneNumber(phoneNumber);
        List<ResultDTO.Result> resultList = new ArrayList<>(resultsEntity.size());
        System.out.println(resultsEntity.toString());
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

}
