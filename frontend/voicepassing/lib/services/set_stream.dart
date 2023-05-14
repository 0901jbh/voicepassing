import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:phone_state/phone_state.dart';
import 'package:unique_device_id/unique_device_id.dart';
import 'package:voicepassing/models/receive_message_model.dart';
import 'package:voicepassing/models/send_message_model.dart';
import 'package:voicepassing/services/notification_controller.dart';
import 'package:voicepassing/services/platform_channel.dart';
import 'package:voicepassing/services/recent_file.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void setStream() async {
  WebSocketChannel ws;
  String phoneNumber = '01012345678';
  late Directory recordDirectory;
  PhoneStateStatus phoneStatus = PhoneStateStatus.NOTHING;
  late String androidId;
  const String recordDirectoryPath = "/storage/emulated/0/Recordings/Call";
  File? targetFile;

  recordDirectory = Directory(recordDirectoryPath);
  androidId = await UniqueDeviceId.instance.getUniqueId() ?? 'unknown';

  PlatformChannel().callStream().listen((event) {
    phoneNumber = event;
  });

  PhoneState.phoneStateStream.listen((event) async {
    debugPrint('sdaf');
    if (event != null) {
      phoneStatus = event;
    }
    // 통화 연결
    if (event == PhoneStateStatus.CALL_STARTED) {
      // 웹소켓 연결
      debugPrint('@');
      ws = WebSocketChannel.connect(
        Uri.parse('ws://k8a607.p.ssafy.io:8080/record'),
      );
      debugPrint('#');
      // 시작 메세지로 기기 식별 번호(SSAID) 전달
      var startMessage = SendMessageModel(
        state: 0,
        androidId: androidId,
      );
      ws.sink.add(jsonEncode(startMessage));

      // 통화 녹음 데이터 전송
      var temp = await recentFile(recordDirectory);
      targetFile = temp is FileSystemEntity ? temp as File : null;
      var offset = 0;
      if (targetFile is File) {
        Timer.periodic(const Duration(seconds: 6), (timer) async {
          Uint8List entireBytes = targetFile!.readAsBytesSync();
          var nextOffset = entireBytes.length;
          var splittedBytes = entireBytes.sublist(offset, nextOffset);
          offset = nextOffset;
          ws.sink.add(splittedBytes);

          //통화 종료
          if (phoneStatus == PhoneStateStatus.CALL_ENDED) {
            debugPrint('END END END END END');
            // 타이머 종료
            timer.cancel();
            // 덜 전달된 마지막 오프셋까지 보내기
            Uint8List entireBytes = targetFile!.readAsBytesSync();
            var nextOffset = entireBytes.length;
            var splittedBytes = entireBytes.sublist(offset, nextOffset);
            offset = nextOffset;
            ws.sink.add(splittedBytes);

            // state 1 보내기
            var endMessage = SendMessageModel(
              state: 1,
              androidId: androidId,
              phoneNumber: phoneNumber,
            );
            ws.sink.add(jsonEncode(endMessage));
          }
        });
      } else {
        // 에러(파일 없음)
        // debugPrint('파일 없음');
        ws.sink.close();
      }

      // 검사 결과 수신
      ws.stream.listen((msg) async {
        if (msg != null) {
          ReceiveMessageModel receivedResult =
              ReceiveMessageModel.fromJson(jsonDecode(msg));
          inspect(receivedResult);
          if (receivedResult.isFinish == true) {
            ws.sink.close();
            debugPrint('${receivedResult.isFinish}');
            if (receivedResult.result != null &&
                receivedResult.result!.results != null) {
              if (receivedResult.result!.totalCategoryScore >= 0.6) {
                if (!await FlutterOverlayWindow.isActive()) {
                  await FlutterOverlayWindow.showOverlay(
                    enableDrag: true,
                    flag: OverlayFlag.defaultFlag,
                    alignment: OverlayAlignment.center,
                    visibility: NotificationVisibility.visibilityPublic,
                    positionGravity: PositionGravity.auto,
                    height: 0,
                    width: 0,
                  );
                  FlutterOverlayWindow.shareData(phoneNumber);
                }
                // 알림 위젯으로 데이터 전달
                FlutterOverlayWindow.shareData(receivedResult);
              }
            }
          } else {
            if (receivedResult.result != null &&
                receivedResult.result!.results != null) {
              if (receivedResult.result!.totalCategoryScore >= 0.6) {
                // 푸시 알림 전송
                NotificationController.cancelNotifications();
                NotificationController.createNewNotification(receivedResult);
              }
            }
          }
        }
      });
    }
  });
}

Future<Timer?> transferVoice({
  required Directory recordDirectory,
  required WebSocketChannel ws,
  required PhoneStateStatus phoneStatus,
  required String androidId,
  required String phoneNumber,
}) async {
  File? targetFile;
  var temp = await recentFile(recordDirectory);
  targetFile = temp is FileSystemEntity ? temp as File : null;
  var offset = 0;
  if (targetFile is File) {
    return Timer.periodic(const Duration(seconds: 6), (timer) async {
      Uint8List entireBytes = targetFile!.readAsBytesSync();
      var nextOffset = entireBytes.length;
      var splittedBytes = entireBytes.sublist(offset, nextOffset);
      offset = nextOffset;
      ws.sink.add(splittedBytes);

      //통화 종료
      if (phoneStatus == PhoneStateStatus.CALL_ENDED) {
        // 타이머 종료
        timer.cancel();
        // 덜 전달된 마지막 오프셋까지 보내기
        Uint8List entireBytes = targetFile.readAsBytesSync();
        var nextOffset = entireBytes.length;
        var splittedBytes = entireBytes.sublist(offset, nextOffset);
        offset = nextOffset;
        ws.sink.add(splittedBytes);

        // state 1 보내기
        var endMessage = SendMessageModel(
          state: 1,
          androidId: androidId,
          phoneNumber: phoneNumber,
        );
        ws.sink.add(jsonEncode(endMessage));
      }
    });
  } else {
    // 에러(파일 없음)
    // debugPrint('파일 없음');
    ws.sink.close();
    return null;
  }
}
