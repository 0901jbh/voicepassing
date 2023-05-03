package com.ssafy.voicepassing.model.entity;

import com.ssafy.voicepassing.util.BaseTimeEntity;
import lombok.*;
import javax.persistence.*;

@Entity
@Table(name="result")
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Getter
@Builder
public class Result extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int resultId;

    @Column(nullable = false)
    private String androidId;

    @Column(nullable = false)
    private String phoneNumber;
    @Column()
    private int category;

    @Column(nullable = false)
    private int risk;


}
