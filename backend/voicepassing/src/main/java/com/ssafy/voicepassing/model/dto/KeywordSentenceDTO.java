package com.ssafy.voicepassing.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;


public class KeywordSentenceDTO {

    @Getter
    @AllArgsConstructor
    @Builder
    public static class KeywordSentence {

        private String sentence;

        private float score;

        private String keyword;
        
        private int category;
    }


}
