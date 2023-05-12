package com.ssafy.voicepassing.model.entity;

import com.ssafy.voicepassing.util.BaseTimeEntity;
import lombok.*;

import javax.persistence.*;

@Entity
@Table(name="keyword")
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Getter
@Builder
@IdClass(KeywordID.class)
public class Keyword{

    @Id
    private String keyword;

    @Column()
    private int count;

    @Id
    private int category;


}
