import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:vibration/vibration.dart';

import 'package:voicepassing/models/receive_message_model.dart';
import 'package:voicepassing/models/send_message_model.dart';
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
  String phoneNumber = '01012345678';
  String phishingNumber = '0';

  @override
  void initState() {
    super.initState();
    FlutterOverlayWindow.overlayListener.listen((msg) async {
      if (msg is Map<String, dynamic> && msg['phoneNumber'] != null) {
        setState(() {
          SendMessageModel callInfoData = SendMessageModel.fromJson(msg);
          phoneNumber = callInfoData.phoneNumber ?? '01012345678';
          androidId = callInfoData.androidId;
        });
        phishingNumber = await ApiService.getPhoneNumber(phoneNumber) ?? '0';
      }
      if (msg is Map<String, dynamic> && msg['result'] != null) {
        setState(() {
          resultData = ReceiveMessageModel.fromJson(msg);
          Vibration.vibrate(pattern: [0, 500, 300, 500]);
          if (resultData.isFinish == true) {
            FlutterOverlayWindow.resizeOverlay(336, 284);
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
