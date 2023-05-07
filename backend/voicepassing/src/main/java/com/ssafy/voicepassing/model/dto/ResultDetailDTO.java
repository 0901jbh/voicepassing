package com.ssafy.voicepassing.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;


public class ResultDetailDTO {

    @Getter
    @AllArgsConstructor
    @Builder
    public static class ResultDetail {

        private int detailId;

        private int resultId;

        private String sentence;
    }


}
