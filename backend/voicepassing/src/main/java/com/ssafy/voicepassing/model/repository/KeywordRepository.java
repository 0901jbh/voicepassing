package com.ssafy.voicepassing.model.repository;

import com.ssafy.voicepassing.model.dto.KeywordDTO;
import com.ssafy.voicepassing.model.entity.Keyword;
import com.ssafy.voicepassing.model.entity.KeywordID;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

public interface KeywordRepository extends JpaRepository<Keyword,KeywordID> {
    List<Keyword> findTop3ByCategoryOrderByCountDesc(int category);
}