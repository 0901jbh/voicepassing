package com.ssafy.voicepassing.model.service;

import com.ssafy.voicepassing.model.dto.KeywordDTO;
import com.ssafy.voicepassing.model.dto.ResultDTO;
import com.ssafy.voicepassing.model.entity.Keyword;

public interface KeywordService {
    public boolean addKeyword(KeywordDTO.Keyword keyword);
    public Keyword addKeywordReturn(KeywordDTO.Keyword keyword);
}
