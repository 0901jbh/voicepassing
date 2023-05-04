package com.ssafy.voicepassing.model.repository;

import com.ssafy.voicepassing.model.entity.ResultDetail;
import com.ssafy.voicepassing.model.entity.ResultDetailID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ResultDetailRepository extends JpaRepository<ResultDetail, ResultDetailID> {
}
