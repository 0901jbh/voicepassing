import 'package:flutter/material.dart';
import 'package:voicepassing/widgets/statistics_widget/highlight_sentence.dart';

class Sentences extends StatefulWidget {
  final List keywordList;
  const Sentences(this.keywordList, {super.key});

  @override
  State<Sentences> createState() => _SentencesState();
}

class _SentencesState extends State<Sentences> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (Map keyword in widget.keywordList) ...[
          HightlightSentence(keyword["sentence"], keyword["keyword"]),
          const SizedBox(
            height: 24,
          )
        ]
      ],
    );
  }
}
