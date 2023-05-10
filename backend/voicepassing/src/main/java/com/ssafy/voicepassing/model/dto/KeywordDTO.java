package com.ssafy.voicepassing.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;


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
        private List<String> type1;
        private List<String> type2;
    }
}
