import 'package:flutter/material.dart';
import 'package:voicepassing/models/case_model.dart';
import 'package:voicepassing/screens/main_screen.dart';
import 'package:voicepassing/widgets/head_bar.dart';
import 'package:voicepassing/widgets/nav_bar.dart';
import 'package:voicepassing/widgets/result/result_list.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

// Todo: 임시로 넣어놓은 데이터, 삭제예정
class _ResultScreenState extends State<ResultScreen> {
  final List<CaseModel> cases = [
    CaseModel(
      50,
      DateTime(2023),
      "사칭",
      ['대포통장', '신용평점', '수사관'],
      [
        '서울중앙지검형사7부 김진태 수사관입니다',
        '신용평점 이라는게 어떤 방법으로든 당일날 바로 상향시키는 건 정상적인 방법으로는 불가능 하거든요'
      ],
    ),
    CaseModel(
      70,
      DateTime(2023),
      "대출",
      ['서울', '정상', '불가능'],
      [
        '서울중앙지검형사7부 김진태 수사관입니다',
        '신용평점 이라는게 어떤 방법으로든 당일날 바로 상향시키는 건 정상적인 방법으로는 불가능 하거든요'
      ],
    ),
    CaseModel(
      90,
      DateTime(2023),
      "사칭",
      ['형사', '당일날', '수사관'],
      [
        '서울중앙지검형사7부 김진태 수사관입니다',
        '신용평점 이라는게 어떤 방법으로든 당일날 바로 상향시키는 건 정상적인 방법으로는 불가능 하거든요'
      ],
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeadBar(
        navPage: const MainScreen(),
        title: const Text('검사 결과'),
        appBar: AppBar(),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const ResultTitle(),
                const SizedBox(
                  height: 20,
                ),
                for (var caseinfo in cases)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: ResultList(
                      caseInfo: caseinfo,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const Navbar(selectedIndex: 3),
      // bottomNavigationBar: const Navbar(),
    );
  }
}

class ResultTitle extends StatelessWidget {
  const ResultTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 315,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    '지난 검사 결과',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w800,
                        fontSize: 20),
                  ),
                  Text('를'),
                ],
              ),
              const Text('확인해보세요')
            ],
          ),
          Image.asset(
            'images/ResultImg.png',
            height: 110,
          )
        ],
      ),
    );
  }
}
