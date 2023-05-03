package com.ssafy.voicepassing.model.service;


import com.ssafy.voicepassing.model.dto.ResultDTO;

import java.util.List;

public interface ResultService {
    //검사 결과 목록 조회
    public List<ResultDTO.Result> getResultList();
    //분석 결과 추가
    public boolean addResult(ResultDTO.Result resultDTO);

    public List<ResultDTO.Result> getResultList(String androidId);
    public ResultDTO.ResultNum getResultNum();

}

