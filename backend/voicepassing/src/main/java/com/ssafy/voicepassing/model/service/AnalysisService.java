package com.ssafy.voicepassing.model.service;

import com.ssafy.voicepassing.model.dto.AIResponseDTO;
import com.ssafy.voicepassing.model.dto.ResultDTO;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;

public interface AnalysisService {


    //clova TTS
    public String SpeechToText(String sessionId, String fileName);
    //text to AI
    public Map<String,Object> analysis(AIResponseDTO.Request rb);




}
