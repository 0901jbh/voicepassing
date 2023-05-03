package com.ssafy.voicepassing.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.*;

public class ResultDTO{
    @Getter
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class Result {

        private int resultId;
        private String androidId;
        private String phoneNumber;
        private float risk;
        private int category;




    }
    @Getter
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class ResultNum {
        private long resultNum;
    }

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class Temp {
        private ArrayList<Double> result;
    }

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class Send {
        private String text;
    }
}
