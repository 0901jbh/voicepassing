package com.ssafy.voicepassing.model.repository;

import com.ssafy.voicepassing.model.entity.Result;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
@Repository
public interface ResultRepository extends JpaRepository<Result,Integer> {
    List<Result> findAllByAndroidId(String androidId);
    List<Result> findAllByPhoneNumber(String phoneNumber);
    List<Result> findByCreatedTimeBetween(LocalDateTime fromTime, LocalDateTime toTime);
}
