package com.ssafy.voicepassing.model.service;

import com.ssafy.voicepassing.model.dto.KeywordDTO;
import com.ssafy.voicepassing.model.dto.ResultDTO;

public interface KeywordService {
    public boolean addKeyword(KeywordDTO.Keyword keyword);
}
