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
public class Keyword{

    @Id
    private String keyword;

    @Column()
    private int count;

    @Column()
    private int category;


}
