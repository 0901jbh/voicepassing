import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as ggg;
import 'package:indexed/indexed.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:voicepassing/screens/analytics_screen.dart';
import 'package:voicepassing/screens/result_screen.dart';
import 'package:voicepassing/screens/search_screen_result.dart';
import 'package:voicepassing/screens/statics_screen.dart';

import 'package:voicepassing/style/color_style.dart';
import 'package:voicepassing/services/permissionChecker.dart';
import 'package:voicepassing/services/set_stream.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:voicepassing/services/api_service.dart';

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
    return
        // Scaffold(
        //     backgroundColor: Colors.white.withOpacity(1),
        //     appBar: AppBar(
        //       actions: [
        //         IconButton(
        //           onPressed: () {
        //             Navigator.of(context).pushNamed("/setting");
        //           },
        //           icon: const Icon(
        //             Icons.settings,
        //             size: 24,
        //           ),
        //         ),
        //       ],
        //       leadingWidth: 120,
        //       leading: Builder(builder: (BuildContext context) {
        //         return SizedBox(
        //           width: 70,
        //           child: Padding(
        //             padding: const EdgeInsets.only(left: 10),
        //             child: Image.asset(
        //               'images/VoiceLogo.png',
        //               height: 30,
        //             ),
        //           ),
        //         );
        //       }),
        //       backgroundColor: Colors.transparent,
        //       foregroundColor: Colors.black,
        //       elevation: 0,
        //     ),
        //     body: FutureBuilder(
        //         future: caseNum,
        //         builder: (BuildContext context, AsyncSnapshot snapshot) {
        //           if (snapshot.hasData) {
        //             return SingleChildScrollView(
        //               child: Center(
        //                 child: Column(
        //                   children: [
        //                     const SizedBox(
        //                       height: 50,
        //                     ),
        //                     Row(
        //                       mainAxisAlignment: MainAxisAlignment.center,
        //                       crossAxisAlignment: CrossAxisAlignment.center,
        //                       children: [
        //                         Flexible(
        //                           flex: 5,
        //                           child: Container(
        //                               child: SizedBox(
        //                             child: Column(
        //                               crossAxisAlignment: CrossAxisAlignment.start,
        //                               children: [
        //                                 StyledText(
        //                                   style: const TextStyle(
        //                                     fontSize: 18,
        //                                     fontWeight: FontWeight.bold,
        //                                   ),
        //                                   text: '<b>보이스피싱</b>',
        //                                   tags: {
        //                                     'b': StyledTextTag(
        //                                         style: const TextStyle(
        //                                             fontSize: 24,
        //                                             fontWeight: FontWeight.bold,
        //                                             color:
        //                                                 ColorStyles.themeLightBlue))
        //                                   },
        //                                 ),
        //                                 StyledText(
        //                                   style: const TextStyle(
        //                                     fontSize: 18,
        //                                     fontWeight: FontWeight.bold,
        //                                   ),
        //                                   text:
        //                                       '<b>${snapshot.data['resultNum']}건</b>을',
        //                                   tags: {
        //                                     'b': StyledTextTag(
        //                                         style: const TextStyle(
        //                                             color: ColorStyles.themeBlue,
        //                                             fontWeight: FontWeight.w800,
        //                                             fontSize: 24))
        //                                   },
        //                                 ),
        //                                 const SizedBox(height: 5),
        //                                 const Text(
        //                                   '찾았어요',
        //                                   style: TextStyle(
        //                                     fontSize: 18,
        //                                     fontWeight: FontWeight.bold,
        //                                   ),
        //                                 )
        //                               ],
        //                             ),
        //                           )),
        //                         ),
        //                         Flexible(
        //                           flex: 3,
        //                           child: Image.asset(
        //                             'images/MainImg.png',
        //                           ),
        //                         )
        //                       ],
        //                     ),
        //                     const SizedBox(
        //                       height: 50,
        //                     ),
        //                     // ignore: prefer_const_constructors
        //                     GestureDetector(
        //                       child: Container(
        //                         width: 315,
        //                         height: 80,
        //                         decoration: BoxDecoration(
        //                           color: isGranted
        //                               ? ColorStyles.themeLightBlue
        //                               : ColorStyles.textDarkGray,
        //                           borderRadius: BorderRadius.circular(12),
        //                         ),
        //                         child: isGranted
        //                             ? Padding(
        //                                 padding: const EdgeInsets.fromLTRB(
        //                                     18, 12, 20, 12),
        //                                 child: Row(
        //                                   mainAxisAlignment:
        //                                       MainAxisAlignment.spaceBetween,
        //                                   children: [
        //                                     const Text('실시간으로 통화를 분석합니다',
        //                                         style: TextStyle(
        //                                             color: Colors.white,
        //                                             fontWeight: FontWeight.w700,
        //                                             fontSize: 15)),
        //                                     ColorSonar(
        //                                         contentAreaRadius: 10.0,
        //                                         waveMotion: WaveMotion.synced,
        //                                         waveFall: 5.0,
        //                                         innerWaveColor:
        //                                             ColorStyles.themeLightBlue,
        //                                         middleWaveColor:
        //                                             const Color.fromARGB(
        //                                                 255, 114, 157, 221),
        //                                         outerWaveColor:
        //                                             const Color.fromARGB(
        //                                                 255, 170, 195, 233),
        //                                         child: CircleAvatar(
        //                                             radius: 20.0,
        //                                             child: Lottie.asset(
        //                                                 'assets/shield.json')))
        //                                   ],
        //                                 ),
        //                               )
        //                             : const Column(
        //                                 mainAxisAlignment: MainAxisAlignment.center,
        //                                 crossAxisAlignment:
        //                                     CrossAxisAlignment.center,
        //                                 children: [
        //                                   Text(
        //                                     '실시간 통화 서비스를 위한 기기 권한이 없습니다',
        //                                     style: TextStyle(
        //                                         color: Colors.white,
        //                                         fontWeight: FontWeight.w700,
        //                                         fontSize: 12),
        //                                   ),
        //                                   SizedBox(height: 5),
        //                                   Text(
        //                                     '기기 권한 설정을 위해 이곳을 눌러주세요',
        //                                     style: TextStyle(
        //                                         color: Colors.white,
        //                                         fontWeight: FontWeight.w700,
        //                                         fontSize: 12),
        //                                   ),
        //                                 ],
        //                               ),
        //                       ),
        //                       onTap: () => {
        //                         if (!isGranted)
        //                           {Navigator.of(context).pushNamed('/permission')}
        //                       },
        //                     ),
        //                     const SizedBox(
        //                       height: 12,
        //                     ),
        //                     const SizedBox(
        //                       width: 315,
        //                       // ignore: prefer_const_constructors
        //                       child: Row(
        //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                         children: [
        //                           ImgButton(
        //                             title: '검사 이력',
        //                             imgName: 'ResultImg',
        //                             routeName: '/result',
        //                           ),
        //                           ImgButton(
        //                               title: '최근 범죄 통계',
        //                               imgName: 'StaticsImg',
        //                               routeName: '/statistics'),
        //                         ],
        //                       ),
        //                     ),
        //                     const SizedBox(
        //                       height: 10,
        //                     ),
        //                     // ignore: prefer_const_constructors
        //                     SizedBox(
        //                       width: 315,
        //                       // ignore: prefer_const_constructors
        //                       child: Row(
        //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                         children: const [
        //                           ImgButton(
        //                             title: '전화번호 검색',
        //                             imgName: 'SearchImg',
        //                             routeName: '/search',
        //                           ),
        //                           ImgButton(
        //                               title: '녹음 파일 검사',
        //                               imgName: 'AnalyticsImg',
        //                               routeName: '/analytics'),
        //                         ],
        //                       ),
        //                     ),
        //                     GestureDetector(
        //                       child: const Text('테스트페이지'),
        //                       onTap: () => Navigator.push(
        //                           context,
        //                           MaterialPageRoute(
        //                               builder: (context) => const titleScreen())),
        //                     )
        //                   ],
        //                 ),
        //               ),
        //             );
        //           }
        //           return const Text('');
        //         }));
        Scaffold(
            extendBodyBehindAppBar: true,
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
                    color: Colors.white,
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
                      'images/logowhite.png',
                      height: 30,
                    ),
                  ),
                );
              }),
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            body: Indexer(children: [
              Indexed(
                index: 1,
                child: Column(
                  children: [
                    Container(
                      height: 350,
                      decoration: const BoxDecoration(
                        color: ColorStyles.newBlue,
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Indexed(
                index: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 90,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: isGranted
                            ? const GrantedBox()
                            : const UngrantedBox()

                        // UngrantedBox(),
                        ),
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: BigButton(
                        icon: MdiIcons.newspaperVariantMultiple,
                        headText: '검사 내역',
                        subText: '보이스피싱 검사 결과를 살펴보세요',
                        page: ResultScreen(),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: BigButton(
                        icon: MdiIcons.folderUploadOutline,
                        headText: '녹음 파일 검사',
                        subText: '녹음 파일을 검사해 보세요',
                        page: AnalyticsScreen(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => ggg.Get.to(() => const StaticsScreen(),
                                transition: ggg.Transition.fade),
                            child: Container(
                              clipBehavior: Clip.hardEdge,
                              height: 100,
                              width: 150,
                              decoration: BoxDecoration(
                                color: ColorStyles.newBlue,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(children: [
                                Transform.translate(
                                  offset: const Offset(20, 10),
                                  child: Transform.scale(
                                    scale: 3.5,
                                    child: const Icon(
                                      MdiIcons.finance,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Transform.translate(
                                  offset: const Offset(40, -20),
                                  child: const Text('통계',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 36)),
                                )
                              ]),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => ggg.Get.to(
                                () => const SearchScreenResult(),
                                transition: ggg.Transition.fade),
                            child: Container(
                              clipBehavior: Clip.hardEdge,
                              height: 100,
                              width: 150,
                              decoration: BoxDecoration(
                                color: ColorStyles.newBlue,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(children: [
                                Transform.scale(
                                  scale: 4,
                                  child: Transform.translate(
                                      offset: const Offset(3, 3.5),
                                      child: const Icon(
                                        MdiIcons.clipboardTextSearch,
                                        color: Colors.white,
                                      )),
                                ),
                                Transform.translate(
                                  offset: const Offset(42, 15),
                                  child: const Text(
                                    '검색',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 36),
                                  ),
                                )
                              ]),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ]));
  }
}

class UngrantedBox extends StatelessWidget {
  const UngrantedBox({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        {Navigator.of(context).pushNamed('/permission')}
      },
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.black.withOpacity(0.2),
        ),
        child: const Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '실시간 통화 서비스를 위한 기기 권한이 없습니다',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 13),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '기기 권한 설정을 위해 이곳을 눌러주세요',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 13),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GrantedBox extends StatelessWidget {
  const GrantedBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white.withOpacity(0.15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              child: Center(
                child: Transform.translate(
                  offset: const Offset(0, -25),
                  child: Lottie.asset('assets/soundwavewhite.json',
                      width: 230, fit: BoxFit.fitWidth, height: 50),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            const Text(
              '보이스패싱이 통화를 보호하고 있습니다',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

class BigButton extends StatelessWidget {
  final IconData icon;
  final String headText;
  final String subText;
  final Widget page;

  const BigButton(
      {super.key,
      required this.icon,
      required this.headText,
      required this.subText,
      required this.page});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ggg.Get.to(() => page, transition: ggg.Transition.fade),
      child: Container(
        height: 110,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 0.1),
              ),
            ]),
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                size: 85,
                color: ColorStyles.newBlue,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    headText,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: ColorStyles.newBlue,
                        fontSize: 30),
                  ),
                  Text(
                    subText,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: ColorStyles.textDarkGray,
                        fontSize: 12),
                  )
                ],
              )
            ],
          ),
        )),
      ),
    );
  }
}
