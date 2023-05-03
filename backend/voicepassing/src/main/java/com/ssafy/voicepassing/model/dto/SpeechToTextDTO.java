package com.ssafy.voicepassing.model.dto;

import java.util.List;
import java.util.Map;

public class SpeechToTextDTO {
    private String result;
    private String message;
    private String token;
    private String version;
    private Params params;
    private int progress;
    private Map<String, Object> keywords;
    private List<Segment> segments;
    private String text;
    private double confidence;
    private List<Speaker> speakers;

    public static class Params {
        private String service;
        private String domain;
        private String lang;
        private String completion;
        private Diarization diarization;
        private List<Object> boostings;
        private String forbiddens;
        private boolean wordAlignment;
        private boolean fullText;
        private boolean noiseFiltering;
        private boolean resultToObs;
        private int priority;
        private Userdata userdata;

        // getters and setters
    }

    public static class Diarization {
        private boolean enable;
        private int speakerCountMin;
        private int speakerCountMax;

        // getters and setters
    }

    public static class Userdata {
        private String _ncp_DomainCode;
        private int _ncp_DomainId;
        private int _ncp_TaskId;
        private String _ncp_TraceId;

        // getters and setters
    }

    public static class Segment {
        private int start;
        private int end;
        private String text;
        private double confidence;
        private Diarization diarization;
        private Speaker speaker;
        private List<Object> words;
        private String textEdited;

        // getters and setters
    }

    public static class Speaker {
        private String label;
        private String name;
        private boolean edited;

        // getters and setters
    }

    public String getText(){
        return text;
    }

    // getters and setters
}
