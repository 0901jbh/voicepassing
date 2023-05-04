import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';
import 'package:voicepassing/models/case_model.dart';
import 'package:voicepassing/style/color_style.dart';
import 'package:voicepassing/widgets/head_bar.dart';
import 'package:voicepassing/widgets/nav_bar.dart';
import 'package:voicepassing/widgets/result/result_detail.dart';

class ResultScreenDetail extends StatefulWidget {
  final CaseModel caseInfo;
  const ResultScreenDetail({super.key, required this.caseInfo});

  @override
  State<ResultScreenDetail> createState() => _ResultScreenDetailState();
}

class _ResultScreenDetailState extends State<ResultScreenDetail> {
  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < widget.caseInfo.sentences.length; i++) {
      for (String word in widget.caseInfo.words) {
        widget.caseInfo.sentences[i] =
            widget.caseInfo.sentences[i].replaceAll(word, '<b>$word</b>');
      }
    }
    return Scaffold(
      appBar: HeadBar(
        title: Text(widget.caseInfo.date.toString()),
        appBar: AppBar(),
      ),
      body: Builder(
        builder: (BuildContext context) {
          const roundedRectangleBorder = RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          );
          return SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '범죄 유형',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ResultDetailList(
                    caseInfo: widget.caseInfo,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    '의심되는 주요 단어',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Card(
                    color: ColorStyles.backgroundBlue,
                    shape: roundedRectangleBorder,
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                        width: 300,
                        child: Text(
                          widget.caseInfo.words.toString(),
                          style: const TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    '주요 단어를 사용한 문장',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Card(
                    shape: roundedRectangleBorder,
                    elevation: 0,
                    color: ColorStyles.backgroundLightBlue,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                        width: 300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var sentence in widget.caseInfo.sentences)
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: StyledText(
                                    text: sentence.toString(),
                                    tags: {
                                      'b': StyledTextTag(
                                          style: const TextStyle(
                                              color: Colors.blue,
                                              fontSize: 30,
                                              fontWeight: FontWeight.w900))
                                    },
                                  )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const Navbar(selectedIndex: 3),
    );
  }
}
