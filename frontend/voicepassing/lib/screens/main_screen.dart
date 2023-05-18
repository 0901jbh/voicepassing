import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:im_animations/im_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:styled_text/styled_text.dart';
import 'package:voicepassing/services/permissionChecker.dart';
import 'package:voicepassing/services/set_stream.dart';
import 'package:voicepassing/style/color_style.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:voicepassing/services/api_service.dart';
import 'package:voicepassing/widgets/img_button.dart';

import 'package:android_intent_plus/android_intent.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Future caseNum = ApiService.getCaseNum();
  static const String _kPortNameOverlay = 'OVERLAY';
  static const String _kPortNameHome = 'UI';
  final _receivePort = ReceivePort();
  SendPort? homePort;

  final windowManagerLock = Object();

  bool isGranted = false;
  List grantedList = [];

  @override
  void initState() {
    super.initState();
    initializer();
    if (isGranted) {
      setStream();
    }

    IsolateNameServer.registerPortWithName(
      _receivePort.sendPort,
      _kPortNameHome,
    );

    // 오버레이에서 상세보기 클릭 이벤트 수신
    _receivePort.listen((event) async {
      const intent = AndroidIntent(
        action: 'android.intent.action.MAIN', //앱의 실행 명령
        category: 'android.intent.category.LAUNCHER',
        package: 'com.example.voicepassing',
        componentName: 'com.example.voicepassing.MainActivity',
      );
      intent.launch();
      Navigator.pushNamed(context, '/result');
    });
  }

  void initializer() async {
    await initializeDateFormatting();
    isGranted = await PermissionChecker().isGranted();
    grantedList = await PermissionChecker().isPermissioned();
    setState(() {});
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
        backgroundColor: Colors.white.withOpacity(1),
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/setting");
              },
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
        body: FutureBuilder(
            future: caseNum,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 5,
                              child: Container(
                                  child: SizedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    StyledText(
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      text: '<b>보이스피싱</b>',
                                      tags: {
                                        'b': StyledTextTag(
                                            style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    ColorStyles.themeLightBlue))
                                      },
                                    ),
                                    StyledText(
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      text:
                                          '<b>${snapshot.data['resultNum']}건</b>을',
                                      tags: {
                                        'b': StyledTextTag(
                                            style: const TextStyle(
                                                color: ColorStyles.themeBlue,
                                                fontWeight: FontWeight.w800,
                                                fontSize: 24))
                                      },
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      '찾았어요',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              )),
                            ),
                            Flexible(
                              flex: 3,
                              child: Image.asset(
                                'images/MainImg.png',
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        // ignore: prefer_const_constructors
                        GestureDetector(
                          child: Container(
                            width: 315,
                            height: 80,
                            decoration: BoxDecoration(
                              color: isGranted
                                  ? ColorStyles.themeLightBlue
                                  : ColorStyles.textDarkGray,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: isGranted
                                ? Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        18, 12, 20, 12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('실시간으로 통화를 분석합니다',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 15)),
                                        ColorSonar(
                                            contentAreaRadius: 10.0,
                                            waveMotion: WaveMotion.synced,
                                            waveFall: 5.0,
                                            innerWaveColor:
                                                ColorStyles.themeLightBlue,
                                            middleWaveColor:
                                                const Color.fromARGB(
                                                    255, 114, 157, 221),
                                            outerWaveColor:
                                                const Color.fromARGB(
                                                    255, 170, 195, 233),
                                            child: CircleAvatar(
                                                radius: 20.0,
                                                child: Lottie.asset(
                                                    'assets/shield.json')))
                                      ],
                                    ),
                                  )
                                : const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '실시간 통화 서비스를 위한 기기 권한이 없습니다',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        '기기 권한 설정을 위해 이곳을 눌러주세요',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                          ),
                          onTap: () => {
                            if (!isGranted)
                              {Navigator.of(context).pushNamed('/permission')}
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const SizedBox(
                          width: 315,
                          // ignore: prefer_const_constructors
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ImgButton(
                                title: '검사 이력',
                                imgName: 'ResultImg',
                                routeName: '/result',
                              ),
                              ImgButton(
                                  title: '최근 범죄 통계',
                                  imgName: 'StaticsImg',
                                  routeName: '/statistics'),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // ignore: prefer_const_constructors
                        SizedBox(
                          width: 315,
                          // ignore: prefer_const_constructors
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              ImgButton(
                                title: '전화번호 검색',
                                imgName: 'SearchImg',
                                routeName: '/search',
                              ),
                              ImgButton(
                                  title: '녹음 파일 검사',
                                  imgName: 'AnalyticsImg',
                                  routeName: '/analytics'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const Text('');
            }));
  }
}
