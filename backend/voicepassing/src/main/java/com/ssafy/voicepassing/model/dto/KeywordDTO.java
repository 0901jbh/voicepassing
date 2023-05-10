package com.ssafy.voicepassing.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;



public class KeywordDTO {

    @Getter
    @AllArgsConstructor
    @Builder
    public static class Keyword {

        private String keyword;

        private int count;

        private int category;
    }

    @Getter
    @AllArgsConstructor
    @Builder
    public static class PopularKeyword {
        private String keyword;
    }
}
