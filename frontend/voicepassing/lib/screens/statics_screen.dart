import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';
import 'package:voicepassing/screens/main_screen.dart';
import 'package:voicepassing/widgets/head_bar.dart';
import 'package:voicepassing/widgets/nav_bar.dart';

class StaticsScreen extends StatefulWidget {
  const StaticsScreen({super.key});

  @override
  State<StaticsScreen> createState() => _ResultScreenState();
}

// Todo: 임시로 넣어놓은 데이터, 삭제예정
class _ResultScreenState extends State<StaticsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeadBar(
        navPage: MainScreen(),
        title: const Text('통계 및 사례'),
        appBar: AppBar(),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Center(
            child: Column(
              children: const [
                SizedBox(
                  height: 20,
                ),
                TopTitle()
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const Navbar(selectedIndex: 1),
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
                text: '<b>통계 사례</b>를 통해',
                tags: {
                  'b': StyledTextTag(
                      style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 30,
                          fontWeight: FontWeight.w600))
                },
              ),
              const Text('보이스피싱을'),
              const Text('예방하세요')
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'images/StaticsImg.png',
              height: 110,
            ),
          )
        ],
      ),
    );
  }
}
