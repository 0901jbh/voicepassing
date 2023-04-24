package com.ssafy.voicepassing.util;

import java.util.Random;

public class RandomUtil {

    private RandomUtil() {}

    public static String randomAuthKey() {
        char[] authKey = new char[8];
        Random randUtil = new Random();

        for(int i=0; i<8; i++) {
            int randInt = randUtil.nextInt(26);
            authKey[i] = (char)(65 + randInt);
        }
        return new String(authKey);
    }

    public static String randomPw() {
        char[] password = new char[8];
        Random randUtil = new Random();

        for(int i=0; i<8; i++) {
            boolean isDigit = randUtil.nextBoolean();
            if(isDigit)
                password[i] = (char)(48 + randUtil.nextInt(10));
            else
                password[i] = (char)(97 + randUtil.nextInt(26));
        }
        return new String(password);
    }
}
