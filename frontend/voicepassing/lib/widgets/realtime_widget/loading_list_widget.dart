import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:voicepassing/style/color_style.dart';

class LoadingListWidget extends StatelessWidget {
  const LoadingListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(6)),
      height: 60,
      width: double.infinity,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        LoadingAnimationWidget.staggeredDotsWave(
            color: ColorStyles.themeLightBlue, size: 30),
        const Text("분석 중",
            style: TextStyle(
              color: ColorStyles.themeLightBlue,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ))
      ]),
    );
  }
}
