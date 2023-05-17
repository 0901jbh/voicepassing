import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';
import 'package:unique_device_id/unique_device_id.dart';
import 'package:voicepassing/models/result_model.dart';
import 'package:voicepassing/screens/main_screen.dart';
import 'package:voicepassing/services/api_service.dart';
import 'package:voicepassing/style/color_style.dart';
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
  late List<ResultModel> resultList;
  bool isLoading = false;
  late String androidId;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    initializer();
  }

  initializer() async {
    androidId = await UniqueDeviceId.instance.getUniqueId() ?? 'unknown';
    await UniqueDeviceId.instance.getUniqueId().then((value) async {
      androidId = value!;
      resultList = await ApiService.getRecentResult(androidId);

      setState(() {
        print(value);
        print(resultList.toString());
        isLoading = true;
      });
    });
// Todo: 임시로 넣어놓은 기기명, androidId로 바꿀예정
  }

  // final List<CaseModel> cases = [
  //   CaseModel(
  //     50,
  //     DateTime(2023),
  //     "사칭",
  //     ['대포통장', '신용평점', '수사관'],
  //     [
  //       '서울중앙지검형사7부 김진태 수사관입니다',
  //       '신용평점 이라는게 어떤 방법으로든 당일날 바로 상향시키는 건 정상적인 방법으로는 불가능 하거든요'
  //     ],
  //   ),
  //   CaseModel(
  //     70,
  //     DateTime(2023),
  //     "대출",
  //     ['서울', '정상', '불가능'],
  //     [
  //       '서울중앙지검형사7부 김진태 수사관입니다',
  //       '신용평점 이라는게 어떤 방법으로든 당일날 바로 상향시키는 건 정상적인 방법으로는 불가능 하거든요'
  //     ],
  //   ),
  //   CaseModel(
  //     90,
  //     DateTime(2023),
  //     "사칭",
  //     ['형사', '당일날', '수사관'],
  //     [
  //       '서울중앙지검형사7부 김진태 수사관입니다',
  //       '신용평점 이라는게 어떤 방법으로든 당일날 바로 상향시키는 건 정상적인 방법으로는 불가능 하거든요'
  //     ],
  //   )
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeadBar(
        navPage: MainScreen(),
        title: const Text('검사 결과'),
        appBar: AppBar(),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const ResultTitle(),
                  const SizedBox(
                    height: 20,
                  ),
                  isLoading
                      ? resultList.isEmpty
                          ? const EmptyContent1()
                          : Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    for (var result in resultList)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 15),
                                        child: ResultList(caseInfo: result),
                                      ),
                                  ],
                                ),
                              ),
                            )
                      : const Text('...'),
                  // for (var caseinfo in resultList)
                  //   Padding(
                  //     padding: const EdgeInsets.only(bottom: 20),
                  //     child: ResultList(
                  //       caseInfo: caseinfo,
                  //     ),
                  //   ),
                ],
              ),
            ),
          );
        },
      ),

      bottomNavigationBar: const Navbar(selectedIndex: 1),
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
