package com.ssafy.voicepassing.model.service;

import com.ssafy.voicepassing.model.dto.KeywordDTO;
import com.ssafy.voicepassing.model.dto.ResultDTO;

import java.util.List;

public interface KeywordService {
    public boolean addKeyword(KeywordDTO.Keyword keyword);

    public List<KeywordDTO.PopularKeyword> getPopularKeyword();
}
