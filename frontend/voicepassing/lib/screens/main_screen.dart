import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_state/phone_state.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:unique_device_id/unique_device_id.dart';

import 'package:voicepassing/models/receive_message_model.dart';
import 'package:voicepassing/models/send_message_model.dart';
import 'package:voicepassing/providers/real_time_result.dart';
import 'package:voicepassing/services/recent_file.dart';
import 'package:voicepassing/screens/analytics_screen.dart';
import 'package:voicepassing/screens/result_screen.dart';
import 'package:voicepassing/screens/search_screen.dart';
import 'package:voicepassing/screens/statics_screen.dart';
import 'package:voicepassing/services/api_service.dart';
import 'package:voicepassing/widgets/img_button.dart';
import 'package:voicepassing/widgets/main_widget/main_logo.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});
  final Future caseNum = ApiService.getCaseNum();

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final count = 283;
  // 통화 상태 감지 및 오버레이 위젯 띄우기 위한 임시 변수
  PhoneStateStatus phoneStatus = PhoneStateStatus.NOTHING;
  bool granted = false;
  final String _recordDirectoryPath = "/storage/emulated/0/Recordings/Call";
  late Directory recordDirectory;
  late File? targetFile;
  late WebSocketChannel _ws;
  late String androidId;
  bool isWidgetOn = false;

  // 권한 요청
  Future<bool> requestPermission() async {
    var status = await Permission.phone.request();

    switch (status) {
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
        return false;
      case PermissionStatus.granted:
        return true;
    }
  }

  @override
  void initState() {
    super.initState();
    initializer();
  }

  void initializer() async {
    await initializeDateFormatting();
    await Permission.phone.request();
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();

    bool reqPermission = await requestPermission();
    if (reqPermission) {
      setStream();
    }
    recordDirectory = Directory(_recordDirectoryPath);
    androidId = await UniqueDeviceId.instance.getUniqueId() ?? '';
    debugPrint('기기식별번호 : $androidId');
  }

  // 통화 상태 감지
  void setStream() {
    PhoneState.phoneStateStream.listen((event) async {
      setState(() {
        if (event != null) {
          phoneStatus = event;
        }
      });
      // 전화 걸려올 때 크기 0인 위젯 생성(추후 수정할 것)
      if (event == PhoneStateStatus.CALL_INCOMING) {
        if (await FlutterOverlayWindow.isActive()) return;
        await FlutterOverlayWindow.showOverlay(
          enableDrag: true,
          flag: OverlayFlag.defaultFlag,
          alignment: OverlayAlignment.center,
          visibility: NotificationVisibility.visibilityPublic,
          positionGravity: PositionGravity.auto,
          height: 400,
          width: 400,
        );
      } else if (event == PhoneStateStatus.CALL_STARTED) {
        // 통화 시작되면 웹소켓 연결
        _ws = WebSocketChannel.connect(
          Uri.parse('ws://k8a607.p.ssafy.io:8080/record'),
        );

        // 웹소켓 연결되면 시작 메세지로 기기 식별 번호(SSAID) 전달
        var startMessage = SendMessageModel(
          state: 0,
          androidId: androidId,
        );
        _ws.sink.add(jsonEncode(startMessage));

        // 통화 녹음 데이터 전송
        transferVoice();

        // 검사 결과 수신
        _ws.stream.listen((msg) {
          if (msg != null) {
            ReceiveMessageModel receivedResult =
                ReceiveMessageModel.fromJson(jsonDecode(msg));
            // 최종 결과 수신
            if (receivedResult.result != null &&
                receivedResult.result!.results != null) {
              if (receivedResult.isFinish) {
                if (receivedResult.result!.totalCategoryScore >= 0.6) {
                  // provider에 저장
                  context.read<RealTimeResult>().update(receivedResult.result!);
                }
                _ws.sink.close();
              } else {
                if (receivedResult.result!.totalCategoryScore >= 0.6) {
                  // provider에 저장
                  context.read<RealTimeResult>().update(receivedResult.result!);
                }
              }
            }
          }
        });
      }
    });
  }

  void transferVoice() async {
    var temp = await recentFile(recordDirectory);
    targetFile = temp is FileSystemEntity ? temp as File : null;
    var offset = 0;
    if (targetFile is File) {
      Timer.periodic(const Duration(seconds: 6), (timer) async {
        debugPrint('🙏🙏🙏🙏🙏🙏🙏');
        Uint8List entireBytes = targetFile!.readAsBytesSync();
        var nextOffset = entireBytes.length;
        var splittedBytes = entireBytes.sublist(offset, nextOffset);
        offset = nextOffset;
        _ws.sink.add(splittedBytes);

        //통화 종료
        if (phoneStatus == PhoneStateStatus.CALL_ENDED) {
          // 타이머 종료
          timer.cancel();
          // 덜 전달된 마지막 오프셋까지 보내기
          Uint8List entireBytes = targetFile!.readAsBytesSync();
          var nextOffset = entireBytes.length;
          var splittedBytes = entireBytes.sublist(offset, nextOffset);
          offset = nextOffset;
          _ws.sink.add(splittedBytes);
          // stateCode 1 보내기
          var endMessage = SendMessageModel(
            state: 1,
            androidId: androidId,
          );
          _ws.sink.add(jsonEncode(endMessage));
        }
      });
    } else {
      // 에러(파일 없음)
      debugPrint('파일 없음');
      _ws.sink.close();
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(1),
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () async {
              if (await FlutterOverlayWindow.isActive()) {
                FlutterOverlayWindow.closeOverlay();
                setState(() {
                  isWidgetOn = false;
                });
              } else {
                await FlutterOverlayWindow.showOverlay(
                  enableDrag: true,
                  flag: OverlayFlag.defaultFlag,
                  alignment: OverlayAlignment.center,
                  visibility: NotificationVisibility.visibilityPublic,
                  positionGravity: PositionGravity.auto,
                );
                setState(() {
                  isWidgetOn = true;
                });
              }
            },
            child: Text(isWidgetOn ? 'OFF' : 'ON'),
          ),
          // 전화 권한
          IconButton(
            onPressed: !granted
                ? () async {
                    bool temp = await requestPermission();
                    setState(() {
                      granted = temp;
                      if (granted) {
                        setStream();
                      }
                    });
                  }
                : null,
            icon: const Icon(
              Icons.perm_phone_msg,
              size: 24,
              color: Colors.amber,
            ),
          ),
          // 오버레이(다른 앱 위에 그리기) 권한
          IconButton(
            onPressed: () async {
              await FlutterOverlayWindow.requestPermission();
            },
            icon: const Icon(
              Icons.picture_in_picture,
              size: 24,
              color: Colors.amber,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.settings,
              size: 24,
            ),
          ),
        ],
        leadingWidth: 120,
        leading: Builder(builder: (BuildContext context) {
          return SizedBox(
            width: 70,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Image.asset(
                'images/VoiceLogo.png',
                height: 30,
              ),
            ),
          );
        }),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ChangeNotifierProvider(
        create: (BuildContext context) => RealTimeResult(),
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              MainLogo(widget: widget),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 315,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    ImgButton(
                      title: '검사 결과',
                      imgName: 'ResultImg',
                      screenWidget: ResultScreen(),
                    ),
                    ImgButton(
                        title: '통계 내용',
                        imgName: 'StaticsImg',
                        screenWidget: StaticsScreen()),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 315,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    ImgButton(
                        title: '검색',
                        imgName: 'SearchImg',
                        screenWidget: SearchScreen()),
                    ImgButton(
                        title: '녹음 파일 검사',
                        imgName: 'AnalyticsImg',
                        screenWidget: AnalyticsScreen()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
