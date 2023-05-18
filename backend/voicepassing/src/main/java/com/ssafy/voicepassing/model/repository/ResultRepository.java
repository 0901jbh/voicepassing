package com.ssafy.voicepassing.model.repository;

import com.ssafy.voicepassing.model.entity.Result;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
@Repository
public interface ResultRepository extends JpaRepository<Result,Integer> {
    List<Result> findAllByAndroidId(String androidId);
    List<Result> findAllByPhoneNumberAndCategoryNotLike(String phoneNumber, int Category);
    List<Result> findByCreatedTimeBetween(LocalDateTime fromTime, LocalDateTime toTime);

    @Query("SELECT COUNT(r), r.category FROM Result r WHERE r.createdTime >= :oneMonthAgo GROUP BY r.category")
    List<Object[]> countByCategoryAndCreatedTimeAfter(@Param("oneMonthAgo") LocalDateTime oneMonthAgo);

    List<Result> findAllByAndroidIdOrderByCreatedTimeDesc(String androidId);
}
