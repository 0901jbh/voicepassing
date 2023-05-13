import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';
import 'package:voicepassing/style/color_style.dart';

class HightlightSentence extends StatelessWidget {
  final String sentence;
  final String keyword;
  const HightlightSentence(this.sentence, this.keyword, {super.key});

  @override
  Widget build(BuildContext context) {
    String newSentence = sentence.replaceAll(keyword, '<b>$keyword</b>');
    return StyledText(
      text: newSentence,
      style: const TextStyle(
        color: ColorStyles.textBlack,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      tags: {
        'b': StyledTextTag(
            style: const TextStyle(
                color: ColorStyles.themeLightBlue, fontSize: 20))
      },
    );
  }
}
