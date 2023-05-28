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
          borderRadius: BorderRadius.circular(8),
          color: isAnalyzing ? ColorStyles.newLightBlue : ColorStyles.themeLightBlue,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 0,
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
      width: double.infinity,
      height: 56,
      child: isAnalyzing
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.white, size: 30),
              ],
            )
          : InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/result');
              },
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "통화가 종료되었습니다.\n버튼을 눌러 상세 정보를 확인해보세요.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
    );
  }
}
