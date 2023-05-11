package com.ssafy.voicepassing.model.repository;

import com.ssafy.voicepassing.model.entity.KeywordSentence;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

public interface KeywordSentenceRepository extends JpaRepository<KeywordSentence,String> {
    KeywordSentence findBySentenceStartsWith(String sentence);

    KeywordSentence findOneByKeywordOrderByScoreDesc(String keyword);

}