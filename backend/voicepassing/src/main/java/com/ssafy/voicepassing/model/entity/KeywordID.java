package com.ssafy.voicepassing.model.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.Objects;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class KeywordID implements Serializable {
    private String keyword;
    private int category;
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof KeywordID)) return false;
        KeywordID keywordID = (KeywordID) o;
        return category == keywordID.category &&
                Objects.equals(keyword, keywordID.keyword);
    }

    @Override
    public int hashCode() {
        return Objects.hash(keyword, category);
    }

}