package com.ssafy.voicepassing.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

public class AIResponseDTO {


    @Getter
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class Request {
      private String text;
      private boolean isFinish;
      private String sessionId;
    }



    @Getter
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class AIResponse {
        private int totalCategory;
        private float totalCategoryScore;
        private List<Result> results;
    }

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class Result {
        private int sentCategory;
        private float sentCategoryScore;
        private String sentKeyword;
        private float keywordScore;
        private String sentence;
    }
}
