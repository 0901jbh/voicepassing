package com.ssafy.voicepassing.model.service;

import com.ssafy.voicepassing.model.dto.ResultDto;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.List;

public interface AnalysisService {


    //검사 파일 올리기
    public String uploadFile(MultipartFile file) throws IOException;
    public String uploadFileAI(MultipartFile multipartFile) throws IOException;


}
