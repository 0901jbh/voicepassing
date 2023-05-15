package com.ssafy.voicepassing.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.time.LocalDateTime;
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
        private LocalDateTime createdTime;



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

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class ResultWithWords{
        private int resultId;
        private String androidId;
        private String phoneNumber;
        private float risk;
        private int category;
        private LocalDateTime createdTime;

        private List<String> keyword;
        private List<String> sentence;

    }

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class CategoryResultNum {
        private List<Integer> categoryList;
    }
    @Getter
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class ResultCount {
        private List<Long> count;
        private List<Integer> category;
    }
}
