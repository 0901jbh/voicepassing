import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:vibration/vibration.dart';

import 'package:voicepassing/models/receive_message_model.dart';
import 'package:voicepassing/widgets/alarm_widget/after_call_notification.dart';
import 'package:voicepassing/widgets/alarm_widget/in_call_notification.dart';

class AlarmWidget extends StatefulWidget {
  const AlarmWidget({Key? key}) : super(key: key);

  @override
  State<AlarmWidget> createState() => _AlarmWidgetState();
}

class _AlarmWidgetState extends State<AlarmWidget> {
  ReceiveMessageModel resultData = ReceiveMessageModel(
    result: TotalResult(
      totalCategory: 1,
      totalCategoryScore: 0.5,
      results: [
        ResultItem(
            sentCategory: 1,
            sentCategoryScore: 0.5,
            sentKeyword: '',
            keywordScore: 0.5,
            sentence: ''),
      ],
    ),
    isFinish: false,
  );

  @override
  void initState() {
    super.initState();
    FlutterOverlayWindow.overlayListener.listen((newResult) {
      if (newResult['result'] != null) {
        setState(() {
          resultData = ReceiveMessageModel.fromJson(newResult);
          Vibration.vibrate();
          if (resultData.isFinish == true) {
            FlutterOverlayWindow.resizeOverlay(336, 276);
          } else {
            FlutterOverlayWindow.resizeOverlay(320, 80);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return resultData.isFinish == true
        ? AfterCallNotification(resultData: resultData)
        : InCallNotification(resultData: resultData);
  }
}
