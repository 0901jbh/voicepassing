import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_state/phone_state.dart';

import 'package:styled_text/styled_text.dart';
import 'package:voicepassing/screens/result_screen.dart';
import 'package:voicepassing/screens/search_screen.dart';
import 'package:voicepassing/widgets/img_button.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final count = 283;
  // 통화 상태 감지 및 오버레이 위젯 띄우기 위한 임시 변수
  PhoneStateStatus phoneStatus = PhoneStateStatus.NOTHING;
  bool granted = false;

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
  }

  // 통화 상태 감지
  void setStream() {
    PhoneState.phoneStateStream.listen((event) async {
      // 전화 걸려올 때 크기 0인 위젯 생성
      if (event == PhoneStateStatus.CALL_INCOMING) {
        if (await FlutterOverlayWindow.isActive()) return;
        await FlutterOverlayWindow.showOverlay(
          enableDrag: true,
          flag: OverlayFlag.defaultFlag,
          alignment: OverlayAlignment.center,
          visibility: NotificationVisibility.visibilityPublic,
          positionGravity: PositionGravity.auto,
          height: 100,
          width: 100,
        );
        debugPrint("위젯 생성");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(1),
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () async {
              if (await FlutterOverlayWindow.isActive()) return;
              await FlutterOverlayWindow.showOverlay(
                enableDrag: true,
                flag: OverlayFlag.defaultFlag,
                alignment: OverlayAlignment.center,
                visibility: NotificationVisibility.visibilityPublic,
                positionGravity: PositionGravity.auto,
                height: 100,
                width: 100,
              );
            },
            child: const Text('SHOW'),
          ),
          IconButton(
            onPressed: () async {
              if (await FlutterOverlayWindow.isActive()) {
                FlutterOverlayWindow.closeOverlay();
              }
            },
            icon: const Icon(
              Icons.cancel,
              size: 24,
              color: Colors.amber,
            ),
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
      body: Builder(
        builder: (BuildContext context) {
          return Center(
            child: Column(
              children: [
                SizedBox(
                  width: 315,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StyledText(
                            text: '오늘 <b>보이스패싱</b>은',
                            tags: {
                              'b': StyledTextTag(
                                  style: const TextStyle(color: Colors.blue))
                            },
                          ),
                          StyledText(
                            text: '<b>$count건</b>을',
                            tags: {
                              'b': StyledTextTag(
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 30))
                            },
                          ),
                          const Text('잡았어요')
                        ],
                      ),
                      Image.asset(
                        'images/MainImg.png',
                        height: 110,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  width: 315,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ImgButton(
                        title: '검사 결과',
                        imgName: 'ResultImg',
                        screenWidget: ResultScreen(),
                      ),
                      ImgButton(
                          title: '통계 내용',
                          imgName: 'StaticsImg',
                          screenWidget: SearchScreen()),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  width: 315,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ImgButton(
                          title: '검색',
                          imgName: 'SearchImg',
                          screenWidget: SearchScreen()),
                      ImgButton(
                          title: '녹음 파일 검사',
                          imgName: 'AnalyticsImg',
                          screenWidget: SearchScreen()),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
