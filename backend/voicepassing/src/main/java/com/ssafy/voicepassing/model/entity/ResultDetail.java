package com.ssafy.voicepassing.model.entity;

import lombok.*;

import javax.persistence.*;

@Entity
@Table(name="resultDetail")
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Getter
@Builder
public class ResultDetail {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int detailId;

    @Column(nullable = false)
    private int resultId;

    @Column(nullable = false)
    private String sentence;


}
