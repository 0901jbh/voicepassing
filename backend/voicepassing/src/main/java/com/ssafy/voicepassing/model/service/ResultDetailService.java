package com.ssafy.voicepassing.model.service;


import com.ssafy.voicepassing.model.dto.ResultDTO;
import com.ssafy.voicepassing.model.dto.ResultDetailDTO;

import java.util.List;

public interface ResultDetailService {

    //분석 결과 추가
    public int addResultDetail(ResultDetailDTO.ResultDetail rdDTO);

}

