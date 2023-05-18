import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:phone_state/phone_state.dart';
import 'package:provider/provider.dart';
import 'package:unique_device_id/unique_device_id.dart';
import 'package:voicepassing/main.dart';
import 'package:voicepassing/models/receive_message_model.dart';
import 'package:voicepassing/models/send_message_model.dart';
import 'package:voicepassing/providers/is_analyzing.dart';
import 'package:voicepassing/providers/realtime_provider.dart';
import 'package:voicepassing/services/notification_controller.dart';
import 'package:voicepassing/services/platform_channel.dart';
import 'package:voicepassing/services/recent_file.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void setStream() async {
  WebSocketChannel? ws;
  String phoneNumber = '01012345678';
  late Directory recordDirectory;
  PhoneStateStatus phoneStatus = PhoneStateStatus.NOTHING;
  late String androidId;
  const String recordDirectoryPath = "/storage/emulated/0/Recordings/Call";
  File? targetFile;
  Timer? timer;
  int offset = 0;

  recordDirectory = Directory(recordDirectoryPath);
  androidId = await UniqueDeviceId.instance.getUniqueId() ?? 'unknown';

  PlatformChannel().callStream().listen((event) {
    if (event is String) {
      phoneNumber = event;
    }
  });

  PhoneState.phoneStateStream.listen((event) async {
    if (event != null) {
      phoneStatus = event;
    }
    // 통화 연결
    if (phoneStatus == PhoneStateStatus.CALL_STARTED) {
      // 웹소켓 연결
      ws = WebSocketChannel.connect(
        Uri.parse('ws://k8a607.p.ssafy.io:8080/record'),
      );
      debugPrint('😊😊😊소켓 연결');
      // 시작 메세지로 기기 식별 번호(SSAID) 전달
      var startMessage = SendMessageModel(
        state: 0,
        androidId: androidId,
      );
      ws?.sink.add(jsonEncode(startMessage));
      debugPrint('😊😊😊시작 메시지 전달');

      App.navigatorKey.currentContext!.read<IsAnalyzing>().on();

      // 통화 녹음 데이터 전송
      var temp = await recentFile(recordDirectory);
      targetFile = temp is FileSystemEntity ? temp as File : null;
      offset = 0;
      if (targetFile is File) {
        timer = Timer.periodic(const Duration(seconds: 6), (timer) async {
          Uint8List entireBytes = targetFile!.readAsBytesSync();
          var nextOffset = entireBytes.length;
          var splittedBytes = entireBytes.sublist(offset, nextOffset);
          offset = nextOffset;
          ws?.sink.add(splittedBytes);
          debugPrint('😊😊😊바이트 전송');
        });

        //통화 종료
        // if (phoneStatus == PhoneStateStatus.CALL_ENDED) {
        // debugPrint('😊😊😊통화 종료');
        // // 타이머 종료
        // timer.cancel();
        // // 덜 전달된 마지막 오프셋까지 보내기
        // Uint8List entireBytes = targetFile!.readAsBytesSync();
        // var nextOffset = entireBytes.length;
        // var splittedBytes = entireBytes.sublist(offset, nextOffset);
        // offset = nextOffset;
        // ws.sink.add(splittedBytes);

        // // var callLog = await CallLog.query(
        // //   dateTimeFrom: DateTime.now().subtract(const Duration(days: 1)),
        // //   dateTimeTo: DateTime.now(),
        // // );
        // // phoneNumber = callLog.first.formattedNumber ?? '010-1234-5678';
        // debugPrint('😊😊😊전화 번호 : $phoneNumber');

        // // state 1 보내기
        // var endMessage = SendMessageModel(
        //   state: 1,
        //   androidId: androidId,
        //   phoneNumber: phoneNumber,
        // );
        // ws.sink.add(jsonEncode(endMessage));
        // debugPrint('😊😊😊종료 메시지');
        // }
      } else {
        // 에러(파일 없음)
        // debugPrint('파일 없음');
        ws?.sink.close();
      }

      // 검사 결과 수신
      ws?.stream.listen((msg) async {
        if (msg != null) {
          ReceiveMessageModel receivedResult =
              ReceiveMessageModel.fromJson(jsonDecode(msg));
          inspect(receivedResult);
          if (receivedResult.isFinish == true) {
            ws?.sink.close();

            App.navigatorKey.currentContext!.read<IsAnalyzing>().off();

            if (receivedResult.result != null &&
                receivedResult.result!.results != null) {
              if (receivedResult.result!.totalCategoryScore >= 0.6 &&
                  receivedResult.result!.totalCategory != 0) {
                if (!await FlutterOverlayWindow.isActive()) {
                  await FlutterOverlayWindow.showOverlay(
                    enableDrag: false,
                    flag: OverlayFlag.defaultFlag,
                    alignment: OverlayAlignment.center,
                    visibility: NotificationVisibility.visibilityPublic,
                    positionGravity: PositionGravity.auto,
                    height: 0,
                    width: 0,
                  );
                  SendMessageModel callInfo = SendMessageModel(
                    state: 1,
                    androidId: androidId,
                    phoneNumber: phoneNumber,
                  );
                  FlutterOverlayWindow.shareData(callInfo);
                }
                // 알림 위젯으로 데이터 전달
                FlutterOverlayWindow.shareData(receivedResult);
              }
            }
          } else {
            if (receivedResult.result != null &&
                receivedResult.result!.results != null) {
              if (receivedResult.result!.totalCategoryScore >= 0.6 &&
                  receivedResult.result!.totalCategory != 0) {
                App.navigatorKey.currentContext!
                    .read<RealtimeProvider>()
                    .add(receivedResult);
                // 푸시 알림 전송
                // Vibration.vibrate(
                //   intensities: [1, 255],
                //   pattern: [300, 300, 500, 300],
                // );
                NotificationController.cancelNotifications();
                NotificationController.createNewNotification(receivedResult);
              }
            }
          }
        }
      });
    } else if (phoneStatus == PhoneStateStatus.CALL_ENDED) {
      debugPrint('😊😊😊통화 종료');
      // 타이머 종료
      timer?.cancel();
      // 덜 전달된 마지막 오프셋까지 보내기
      Uint8List entireBytes = targetFile!.readAsBytesSync();
      var nextOffset = entireBytes.length;
      var splittedBytes = entireBytes.sublist(offset, nextOffset);
      offset = nextOffset;
      ws?.sink.add(splittedBytes);

      // var callLog = await CallLog.query(
      //   dateTimeFrom: DateTime.now().subtract(const Duration(days: 1)),
      //   dateTimeTo: DateTime.now(),
      // );
      // phoneNumber = callLog.first.formattedNumber ?? '010-1234-5678';
      debugPrint('😊😊😊전화 번호 : $phoneNumber');

      // state 1 보내기
      var endMessage = SendMessageModel(
        state: 1,
        androidId: androidId,
        phoneNumber: phoneNumber,
      );
      ws?.sink.add(jsonEncode(endMessage));
      debugPrint('😊😊😊종료 메시지');
    }
  });
}
