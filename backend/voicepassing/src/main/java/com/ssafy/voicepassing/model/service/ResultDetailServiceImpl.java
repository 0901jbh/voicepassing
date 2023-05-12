package com.ssafy.voicepassing.model.service;


import com.ssafy.voicepassing.model.dto.ResultDTO;
import com.ssafy.voicepassing.model.dto.ResultDetailDTO;
import com.ssafy.voicepassing.model.entity.Result;
import com.ssafy.voicepassing.model.entity.ResultDetail;
import com.ssafy.voicepassing.model.repository.ResultDetailRepository;
import com.ssafy.voicepassing.model.repository.ResultRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import javax.persistence.PersistenceException;
import java.util.ArrayList;
import java.util.List;


@Service
@RequiredArgsConstructor
public class ResultDetailServiceImpl implements ResultDetailService {

    private final ResultDetailRepository resultDetailRepository;


    @Override
    public int addResultDetail(ResultDetailDTO.ResultDetail rdDTO) {
        ResultDetail rd = ResultDetail.builder()
                .resultId(rdDTO.getResultId())
                .sentence(rdDTO.getSentence())
                .build();
        ResultDetail rd2 = resultDetailRepository.save(rd);
        return rd2.getDetailId();
    }
}
