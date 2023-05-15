import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:vibration/vibration.dart';

import 'package:voicepassing/models/receive_message_model.dart';
import 'package:voicepassing/services/api_service.dart';
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
  String androidId = 'unknown';
  String phoneNumber = '';
  int phishingNumber = 0;

  @override
  void initState() {
    super.initState();
    FlutterOverlayWindow.overlayListener.listen((msg) async {
      inspect(msg);
      if (msg['phoneNumber'] != null) {
        setState(() {
          phoneNumber = msg['phoneNumber'];
          androidId = msg['androidId'];
        });
        phishingNumber = await ApiService.getPhoneNumber(phoneNumber);
      }
      if (msg['result'] != null) {
        setState(() {
          resultData = ReceiveMessageModel.fromJson(msg);
          Vibration.vibrate(pattern: [0, 500, 300, 500]);
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
        ? AfterCallNotification(
            resultData: resultData,
            phoneNumber: phoneNumber,
            phishingNumber: phishingNumber,
            androidId: androidId,
          )
        : InCallNotification(resultData: resultData);
  }
}
