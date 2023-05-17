import 'package:flutter/material.dart';
import 'package:voicepassing/style/color_style.dart';

class RealtimeHeadwidget extends StatelessWidget {
  const RealtimeHeadwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          children: [
            Text("통화 중 분석",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: ColorStyles.themeLightBlue)),
            SizedBox(height: 20),
            Text("통화 중 발생하는 실시간",
                style: TextStyle(
                    fontSize: 15,
                    // fontWeight: FontWeight.bold,
                    color: ColorStyles.textBlack)),
            SizedBox(height: 3),
            Text("알람을 확인해보세요",
                style: TextStyle(
                    fontSize: 15,
                    // fontWeight: FontWeight.bold,
                    color: ColorStyles.textBlack)),
          ],
        ),
        SizedBox(height: 150, child: Image.asset('images/Realtime.png'))
      ],
    );
  }
}
