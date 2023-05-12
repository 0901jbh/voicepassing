import 'package:flutter/material.dart';
import 'package:voicepassing/style/color_style.dart';

class Keywords extends StatefulWidget {
  final List keywordList;

  const Keywords(this.keywordList, {super.key});

  @override
  State<Keywords> createState() => _KeywordsState();
}

class _KeywordsState extends State<Keywords> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        for (String keyword in widget.keywordList) ...[
          Text(
            keyword,
            style: const TextStyle(
                color: ColorStyles.themeLightBlue,
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
        ]
      ],
    );
  }
}
