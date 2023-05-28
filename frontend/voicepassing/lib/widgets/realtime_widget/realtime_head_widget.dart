import 'package:flutter/material.dart';
import 'package:voicepassing/style/color_style.dart';

class RealtimeHeadwidget extends StatelessWidget {
  const RealtimeHeadwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('images/ai_running.gif', width: 250,),
          const Text(
            '실시간 AI 분석 중', 
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.w700, 
              color: ColorStyles.themeLightBlue,
            ),
          ),
        ],
      ),
    );
  }
}
