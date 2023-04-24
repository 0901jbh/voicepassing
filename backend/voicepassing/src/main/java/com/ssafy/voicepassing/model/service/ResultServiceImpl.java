package com.ssafy.voicepassing.model.service;


import com.ssafy.voicepassing.model.dto.ResultDto;
import com.ssafy.voicepassing.model.entity.Result;
import com.ssafy.voicepassing.model.repository.ResultRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;


@Service
@RequiredArgsConstructor
public class ResultServiceImpl implements ResultService {

    private final ResultRepository resultRepository;

    @Override
    public List<ResultDto.Result> getResultList() {
        List<Result> resultsEntity = resultRepository.findAll();


        List<ResultDto.Result> resultList = new ArrayList<>();
        for (Result result: resultsEntity) {
            ResultDto.Result resultDto = buildResult(result);
            resultList.add(resultDto);
        }
        return resultList;

    }
    private ResultDto.Result buildResult(Result result){
        ResultDto.Result resultDto = ResultDto.Result.builder()
                .resultId(result.getResultId())
                .androidId(result.getAndroidId())
                .category(result.getCategory())
                .risk(result.getRisk())
                .text(result.getText())
                .build();
        return resultDto;
    }
}
