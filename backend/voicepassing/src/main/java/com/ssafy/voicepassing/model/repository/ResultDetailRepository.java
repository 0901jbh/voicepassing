package com.ssafy.voicepassing.model.repository;

import com.ssafy.voicepassing.model.entity.ResultDetail;
import com.ssafy.voicepassing.model.entity.ResultDetailID;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ResultDetailRepository extends JpaRepository<ResultDetail, ResultDetailID> {
    List<String> findAllByResultId(int resultId);

}
