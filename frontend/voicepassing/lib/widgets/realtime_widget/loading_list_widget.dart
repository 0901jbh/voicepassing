import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:voicepassing/style/color_style.dart';

class LoadingListWidget extends StatelessWidget {
  const LoadingListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          color: ColorStyles.themeLightBlue),
      width: double.infinity,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        LoadingAnimationWidget.staggeredDotsWave(color: Colors.white, size: 30),
        const Text("분석 중",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            )),
      ]),
    );
  }
}
