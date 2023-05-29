import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:voicepassing/models/receive_message_model.dart';
import 'package:voicepassing/providers/is_analyzing.dart';
import 'package:voicepassing/providers/realtime_provider.dart';
import 'package:voicepassing/services/notification_controller.dart';
import 'package:voicepassing/style/color_style.dart';

class LoadingListWidget extends StatefulWidget {
  const LoadingListWidget({super.key});

  @override
  State<LoadingListWidget> createState() => _LoadingListWidgetState();
}

class _LoadingListWidgetState extends State<LoadingListWidget> {
  @override
  Widget build(BuildContext context) {
    bool isAnalyzing = context.watch<IsAnalyzing>().isAnalyzing;
    List<ReceiveMessageModel> data =
        context.watch<RealtimeProvider>().realtimeDataList;
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color:
            isAnalyzing ? ColorStyles.newLightBlue : ColorStyles.themeLightBlue,
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
                if (data.isEmpty) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/main', (route) => false);
                } else {
                  Navigator.pushNamed(context, '/result');
                }
                NotificationController.cancelNotifications();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data.isEmpty
                        ? "통화가 종료되었습니다.\n버튼을 누르면 메인화면으로 돌아갑니다."
                        : "통화가 종료되었습니다.\n버튼을 눌러 상세 정보를 확인해보세요.",
                    style: const TextStyle(
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
