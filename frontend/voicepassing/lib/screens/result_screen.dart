import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:styled_text/styled_text.dart';
import 'package:unique_device_id/unique_device_id.dart';
import 'package:voicepassing/models/result_model.dart';
import 'package:voicepassing/screens/main_screen.dart';
import 'package:voicepassing/services/api_service.dart';
import 'package:voicepassing/style/color_style.dart';
import 'package:voicepassing/widgets/nav_bar.dart';
import 'package:voicepassing/widgets/result/result_list.dart';

import '../widgets/new_head_bar.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late List<ResultModel> resultList;
  bool isLoading = false;
  late String androidId;

  @override
  void initState() {
    super.initState();
    initializer();
  }

  initializer() async {
    androidId = await UniqueDeviceId.instance.getUniqueId() ?? 'unknown';
    await UniqueDeviceId.instance.getUniqueId().then((value) async {
      androidId = value!;
      resultList = await ApiService.getRecentResult('f6ebc130a8a9709d');

      setState(() {
        isLoading = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.background,
      appBar: const NewHeadBar(
        navPage: MainScreen(),
        name: 'result',
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: [              
                  isLoading
                      ? resultList.isEmpty
                          ? const EmptyContent1()
                          : Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 15),
                                    for (var result in resultList)
                                      Padding(
                                        padding:
                                            const EdgeInsets.fromLTRB(14, 10, 14, 10),
                                        child: ResultList(caseInfo: result),
                                      ),
                                    const SizedBox(height: 15),
                                  ],
                                ),
                              ),
                            )
                      : Column(
                          children: [
                            const SizedBox(
                              height: 150,
                            ),
                            Center(
                              child: LoadingAnimationWidget.staggeredDotsWave(
                                  color: ColorStyles.themeLightBlue, size: 30),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const Navbar(selectedIndex: 1),
    );
  }
}

class ResultTitle extends StatelessWidget {
  const ResultTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Flexible(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '지난 검사 결과',
                        style: TextStyle(
                            color: ColorStyles.themeLightBlue,
                            fontWeight: FontWeight.w700,
                            fontSize: 18),
                      ),
                      Text('를'),
                    ],
                  ),
                  Text('확인해보세요')
                ],
              ),
            ),
            Flexible(
              flex: 5,
              child: Image.asset(
                'images/ResultImg.png',
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EmptyContent1 extends StatelessWidget {
  const EmptyContent1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Image.asset(
                'images/empty.png',
                height: 180,
              ),
            ),
            StyledText(
              text: '<b>정보없음</b>',
              tags: {
                'b': StyledTextTag(
                    style: const TextStyle(
                        color: ColorStyles.themeLightBlue,
                        fontSize: 27,
                        fontWeight: FontWeight.w700))
              },
            ),
            const SizedBox(
              height: 10,
            ),
            const Text('지난 검사 결과가 없습니다')
          ],
        ),
      ),
    );
  }
}
