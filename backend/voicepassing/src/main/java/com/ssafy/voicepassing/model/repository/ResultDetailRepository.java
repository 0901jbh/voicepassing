package com.ssafy.voicepassing.model.repository;

import com.ssafy.voicepassing.model.entity.ResultDetail;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ResultDetailRepository extends JpaRepository<ResultDetail, Integer> {
    List<ResultDetail> findAllByResultId(int resultId);

}
