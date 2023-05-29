import 'package:flutter/material.dart';
import 'package:voicepassing/style/shadow_style.dart';
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
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              boxShadow: [ShadowStyle.wideShadow],
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
            ),
            child: HightlightSentence(keyword["sentence"], keyword["keyword"]),
          ),
          const SizedBox(
            height: 24,
          )
        ]
      ],
    );
  }
}
