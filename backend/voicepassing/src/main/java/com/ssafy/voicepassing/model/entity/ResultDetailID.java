package com.ssafy.voicepassing.model.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ResultDetailID implements Serializable {
    private int detailId;
    private int resultId;

}