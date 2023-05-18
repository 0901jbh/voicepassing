import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:voicepassing/providers/is_analyzing.dart';
import 'package:voicepassing/style/color_style.dart';

class LoadingListWidget extends StatefulWidget {
  const LoadingListWidget({super.key});

  @override
  State<LoadingListWidget> createState() => _LoadingListWidgetState();
}

class _LoadingListWidgetState extends State<LoadingListWidget> {
  @override
  Widget build(BuildContext context) {
    var isAnalyzing = context.watch<IsAnalyzing>().isAnalyzing;
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          color: ColorStyles.themeLightBlue),
      width: double.infinity,
      height: 70,
      child: isAnalyzing
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.white, size: 30),
                const Text(
                  "분석 중",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          : const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "통화가 종료되었습니다",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
    );
  }
}
