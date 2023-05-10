package com.ssafy.voicepassing.model.repository;

import com.ssafy.voicepassing.model.entity.Keyword;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface KeywordRepository extends JpaRepository<Keyword,String> {
    List<Keyword> findAllByOrderByCountDesc();

}