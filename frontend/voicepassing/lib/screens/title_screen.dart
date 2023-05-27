import 'package:flutter/material.dart';
import 'package:indexed/indexed.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:voicepassing/style/color_style.dart';

class titleScreen extends StatelessWidget {
  const titleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  height: 270,
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
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 70,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: UngrantedBox(),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: BigButton(
                        icon: MdiIcons.newspaperVariantMultiple,
                        headText: '검사내역',
                        subText: '보이스피싱 검사 결과를 살펴보세요'),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: BigButton(
                        icon: MdiIcons.folderUploadOutline,
                        headText: '녹음파일 검사',
                        subText: '녹음파일을 검사해 보세요'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
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
                        Container(
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
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ]));
  }
}

class UngrantedBox extends StatelessWidget {
  const UngrantedBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.black.withOpacity(0.2),
      ),
      child: const Padding(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        child: Center(
          child: Column(
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white.withOpacity(0.15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              child: Center(
                child: Transform.translate(
                  offset: const Offset(0, -25),
                  child: Lottie.asset('assets/soundwavewhite.json',
                      width: 200, fit: BoxFit.fitWidth, height: 30),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
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

  const BigButton(
      {super.key,
      required this.icon,
      required this.headText,
      required this.subText});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
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
              size: 69,
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
    );
  }
}
