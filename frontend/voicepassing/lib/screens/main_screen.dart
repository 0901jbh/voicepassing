import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';
import 'package:voicepassing/screens/analytics_screen.dart';
import 'package:voicepassing/screens/result_screen.dart';
import 'package:voicepassing/screens/search_screen.dart';
import 'package:voicepassing/screens/statics_screen.dart';
import 'package:voicepassing/widgets/img_button.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});
  final count = 283;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(1),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.settings,
                size: 24,
              ))
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
          );
        },
      ),
    );
  }
}
