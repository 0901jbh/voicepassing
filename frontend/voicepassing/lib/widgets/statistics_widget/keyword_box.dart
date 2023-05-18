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
  late KeywordModel resultList;
  late Map result;
  @override
  void initState() {
    super.initState();
    initializer();
  }

  initializer() async {
    resultList = await ApiService.getKeywordSentence();
    setState(() {
      result = {
        "1": resultList.keywordSentence1,
        "2": resultList.keywordSentence2,
        "3": resultList.keywordSentence3
      };
      isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    void changeNum(int num) {
      setState(() {
        selected = num;
      });
    }

    if (isLoading) {
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
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
