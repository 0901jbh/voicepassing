import 'package:circle_progress_bar/circle_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:voicepassing/widgets/result/double_value_text_with_circle.dart';

class RealtimeCircleProgressBar extends StatelessWidget {
  final Color textColor;
  final double score;

  const RealtimeCircleProgressBar({
    super.key,
    required this.textColor,
    required this.score,
  });
  @override
  Widget build(BuildContext context) {
    return CircleProgressBar(
      foregroundColor: textColor,
      backgroundColor: Colors.transparent,
      strokeWidth: 10,
      // value/1 표시
      value: score,
      child: DoubleValueTextWithCircle(
        style: TextStyle(
            color: textColor, fontWeight: FontWeight.w500, fontSize: 20),
        fractionDigits: 0,
        count: score * 100,
        unit: '',
        duration: const Duration(microseconds: 500),
      ),
    );
  }
}
