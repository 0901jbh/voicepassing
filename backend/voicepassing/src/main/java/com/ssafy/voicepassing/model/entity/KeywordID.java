package com.ssafy.voicepassing.model.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class KeywordID implements Serializable {
    private String keyword;
    private int category;

}