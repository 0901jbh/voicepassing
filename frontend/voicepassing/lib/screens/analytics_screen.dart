import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';
import 'package:voicepassing/screens/main_screen.dart';
import 'package:voicepassing/widgets/head_bar.dart';
import 'package:voicepassing/widgets/nav_bar.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _ResultScreenState();
}

// Todo: 임시로 넣어놓은 데이터, 삭제예정
class _ResultScreenState extends State<AnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeadBar(
        navPage: MainScreen(),
        title: const Text('녹음 파일 검사'),
        appBar: AppBar(),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Center(
            child: Container(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const TopTitle(),
                  const SizedBox(
                    height: 50,
                  ),
                  Image.asset(
                    'images/FileButton.png',
                    height: 200,
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const Navbar(selectedIndex: 4),
      // bottomNavigationBar: const Navbar(),
    );
  }
}

class TopTitle extends StatelessWidget {
  const TopTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 330,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StyledText(
                text: '<b>통화 음성 파일</b>을',
                tags: {
                  'b': StyledTextTag(
                      style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 22,
                          fontWeight: FontWeight.w600))
                },
              ),
              const Text('검사할 수 있습니다.'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'images/AnalyticstitleImg.png',
              height: 100,
            ),
          )
        ],
      ),
    );
  }
}
