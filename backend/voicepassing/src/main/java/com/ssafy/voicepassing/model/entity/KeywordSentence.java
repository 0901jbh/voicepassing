package com.ssafy.voicepassing.model.entity;

import lombok.*;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name="keywordSentence")
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Getter
@Builder
public class KeywordSentence {

    @Id
    private String sentence;

    @Column(nullable = false)
    private float score;

    @Column(nullable = false)
    private String keyword;

    @Column(nullable = false)
    private int category;
}
