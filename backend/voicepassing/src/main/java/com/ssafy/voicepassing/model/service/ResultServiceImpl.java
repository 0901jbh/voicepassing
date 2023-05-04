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
            resultList.add(resultDto);
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
