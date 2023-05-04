package com.ssafy.voicepassing.model.repository;

import com.ssafy.voicepassing.model.entity.Result;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ResultRepository extends JpaRepository<Result,Integer> {
    List<Result> findAllByAndroidId(String androidId);
    List<Result> findAllByPhoneNumber(String phoneNumber);

}
