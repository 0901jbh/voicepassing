import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';
import 'package:voicepassing/screens/main_screen.dart';
import 'package:voicepassing/style/color_style.dart';
import 'package:voicepassing/widgets/head_bar.dart';
import 'package:voicepassing/widgets/nav_bar.dart';
import 'package:voicepassing/widgets/statistics_widget/chart_box.dart';
import 'package:voicepassing/widgets/statistics_widget/keyword_box.dart';

class StaticsScreen extends StatefulWidget {
  const StaticsScreen({super.key});

  @override
  State<StaticsScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<StaticsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeadBar(
        navPage: const MainScreen(),
        title: const Text('통계 및 사례'),
        appBar: AppBar(),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const TopTitle(),
                ChartBox(),
                const KeywordBox(),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const Navbar(selectedIndex: 2),
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
                          color: ColorStyles.themeLightBlue,
                          fontSize: 30,
                          fontWeight: FontWeight.w600))
                },
              ),
              const Text('보이스피싱을'),
              const Text('예방하세요')
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'images/StaticsImg.png',
                height: 100,
              ),
            ),
          )
        ],
      ),
    );
  }
}
