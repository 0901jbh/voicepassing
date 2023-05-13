import 'package:flutter/material.dart';
import 'package:voicepassing/models/keyword_model.dart';
import 'package:voicepassing/services/api_service.dart';
import 'package:voicepassing/style/color_style.dart';
import 'package:voicepassing/widgets/statistics_widget/category_button.dart';
import 'package:voicepassing/widgets/statistics_widget/keywords.dart';
import 'package:voicepassing/widgets/statistics_widget/setences.dart';

class KeywordBox extends StatefulWidget {
  const KeywordBox({super.key});

  @override
  State<KeywordBox> createState() => _KeywordBoxState();
}

class _KeywordBoxState extends State<KeywordBox> {
  int selected = 0;
  bool isLoading = false;
  late Future<KeywordModel> resultList;

  @override
  void initState() {
    super.initState();
    initializer();
  }

  initializer() async {
    resultList = ApiService.getKeywordSentence();
    print(resultList);
    setState(() {
      isLoading = true;
    });
  }

  Map result = {
    "1": [
      {
        "sentence": "네 다름이 아니고 본인과 관련된 명의도용 사건 때문에 네 가지 사실 확인차 연락을 드렸습니다.",
        "score": 0.0182598,
        "keyword": "관련",
        "category": 1
      },
      {
        "sentence": "저는 서울중앙지검 서울중앙지검에 서울중앙지검입니다.",
        "score": 0.624717,
        "keyword": "서울중앙지검",
        "category": 1
      },
      {
        "sentence": "여기 서울지검 첨단범죄수사팀의 김민재 수사관이라고 합니다.",
        "score": 0.725886,
        "keyword": "첨단범죄수사팀",
        "category": 1
      }
    ],
    "2": [
      {
        "sentence": "당일 만기 상환 제도에서 저축은행으로부터 기존의 고객을 빼앗아 올 것입니다.",
        "score": 0.378085,
        "keyword": "상환",
        "category": 2
      },
      {
        "sentence": "검토 부서에서 현재 등급이 올라가고 있음을 확인하는 즉시 보증이 발행되고 대출금이 지급됩니다.",
        "score": 0.327627,
        "keyword": "검토",
        "category": 2
      },
      {
        "sentence":
            "첫 번째는 당일 만기 상한제도로 기존 고객을 모아 저축은행에서 어느 정도 기존 고객을 확보하고 있다는 것입니다.",
        "score": 0.146456,
        "keyword": "고객",
        "category": 2
      }
    ],
    "3": [
      {
        "sentence": "너나 조선족 냄새가 솔솔 난다",
        "score": 0.555712,
        "keyword": "조선족",
        "category": 3
      }
    ]
  };
  @override
  Widget build(BuildContext context) {
    void changeNum(int num) {
      setState(() {
        selected = num;
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "주로 등장하는 키워드와 문장",
          textAlign: TextAlign.start,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CategoryButton(0, selected, "기관사칭형", changeNum),
                CategoryButton(1, selected, "대출빙자형", changeNum),
                CategoryButton(2, selected, "기타", changeNum)
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: ColorStyles.backgroundBlue,
              ),
              child: Keywords(result[(selected + 1).toString()]),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 6),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: ColorStyles.backgroundBlue,
              ),
              child: Sentences(result[(selected + 1).toString()]),
            ),
          ],
        )
      ],
    );
  }
}
