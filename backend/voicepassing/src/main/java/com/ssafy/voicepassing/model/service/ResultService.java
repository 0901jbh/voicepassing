package com.ssafy.voicepassing.model.service;


import com.ssafy.voicepassing.model.dto.ResultDTO;

import java.util.List;

public interface ResultService {

    //분석 결과 추가
    public int addResult(ResultDTO.Result resultDTO);

    public List<ResultDTO.Result> getResultList(String androidId);
    public ResultDTO.ResultNum getResultNum();
    public List<ResultDTO.Result> searchByPhoneNumber(String phoneNumber);

    public List<ResultDTO.ResultWithWords> getResults(String androidId);

}

