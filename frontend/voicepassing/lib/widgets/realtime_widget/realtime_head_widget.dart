import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voicepassing/providers/is_analyzing.dart';
import 'package:voicepassing/style/color_style.dart';

class RealtimeHeadwidget extends StatelessWidget {
  const RealtimeHeadwidget({super.key});

  @override
  Widget build(BuildContext context) {
    bool isAnalyzing = context.watch<IsAnalyzing>().isAnalyzing;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(isAnalyzing ? 'images/ai_running.gif' : 'images/ai_done.png', width: 250,),
          Text(
            isAnalyzing ? '실시간 AI 분석 중' : '실시간 AI 분석 종료', 
            style: const TextStyle(
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
