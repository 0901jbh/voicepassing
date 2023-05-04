package com.ssafy.voicepassing.model.repository;

import com.ssafy.voicepassing.model.entity.KeywordSentence;
import org.springframework.data.jpa.repository.JpaRepository;

public interface KeywordSentenceRepository extends JpaRepository<KeywordSentence,String> {
}