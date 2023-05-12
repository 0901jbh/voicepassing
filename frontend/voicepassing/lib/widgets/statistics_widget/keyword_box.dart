import 'package:flutter/material.dart';
import 'package:voicepassing/widgets/statistics_widget/category_button.dart';

class KeywordBox extends StatefulWidget {
  const KeywordBox({super.key});

  @override
  State<KeywordBox> createState() => _KeywordBoxState();
}

class _KeywordBoxState extends State<KeywordBox> {
  int selected = 0;
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
        Text(
          "주로 등장하는 키워드와 문장 $selected",
          textAlign: TextAlign.start,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CategoryButton(0, selected, "기관사칭형", changeNum),
                  CategoryButton(1, selected, "대출빙자형", changeNum),
                  CategoryButton(2, selected, "기타", changeNum)
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
