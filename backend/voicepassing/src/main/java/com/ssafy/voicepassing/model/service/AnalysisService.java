package com.ssafy.voicepassing.model.service;

import com.ssafy.voicepassing.model.dto.AIResponseDTO;
import com.ssafy.voicepassing.model.dto.ResultDTO;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;

public interface AnalysisService {



    //upload_file clova TTS
    public String FileSpeechToText(MultipartFile file) throws IOException;

    //multipartfile -> file
    public File mTF(MultipartFile mfile) throws IOException;


    //clova TTS
    public String SpeechToText();
    //text to AI
    public Map<String,Object> recommend(AIResponseDTO.Request rb);

    //result to front
    public Map<String,Object> getResult(AIResponseDTO.Request rb);



    //검사 파일 올리기
    public String uploadFile(MultipartFile file) throws IOException;
    public String uploadFileAI(MultipartFile multipartFile) throws IOException;


}
