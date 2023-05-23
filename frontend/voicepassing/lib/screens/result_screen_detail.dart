import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:styled_text/styled_text.dart';
import 'package:voicepassing/models/result_model.dart';
import 'package:voicepassing/style/color_style.dart';

import 'package:voicepassing/widgets/nav_bar.dart';
import 'package:voicepassing/widgets/result/result_detail.dart';

import 'package:voicepassing/widgets/head_bar_no_rewind.dart';

class ResultScreenDetail extends StatefulWidget {
  final ResultModel caseInfo;
  const ResultScreenDetail({super.key, required this.caseInfo});

  @override
  State<ResultScreenDetail> createState() => _ResultScreenDetailState();
}

class _ResultScreenDetailState extends State<ResultScreenDetail> {
  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < widget.caseInfo.sentences!.length; i++) {
      for (String word in widget.caseInfo.words!) {
        widget.caseInfo.sentences![i] =
            widget.caseInfo.sentences![i].replaceAll(word, '<b>$word</b>');
      }
    }
    return Scaffold(
      appBar: HeadBar(
        title: Text(DateFormat('yy.M.d')
            .format(DateTime.parse(widget.caseInfo.date.toString()))),
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
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 29,
                    ),
                    const Text(
                      '  🚨 범죄 유형',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    ResultDetailList(
                      caseInfo: widget.caseInfo,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      '  💬 의심되는 주요 단어',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: ColorStyles.backgroundBlue,
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                widget.caseInfo.words != null
                                    ? widget.caseInfo.words!.join('  ')
                                    : "",
                                style: const TextStyle(
                                    color: ColorStyles.themeLightBlue,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    const Text(
                      '  💬 주요 단어를 사용한 문장',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    const SizedBox(height: 3),
                    for (int i = 0; i < widget.caseInfo.scores!.length; i++)
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 7),
                              child: Card(
                                shape: roundedRectangleBorder,
                                elevation: 0,
                                color: widget.caseInfo.scores![i] > 0.8
                                    ? ColorStyles.backgroundRed
                                    : ColorStyles.backgroundYellow,
                                child: Padding(
                                    padding: const EdgeInsets.all(17),
                                    child: StyledText(
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: ColorStyles.textDarkGray,
                                          fontSize: 15),
                                      text: widget.caseInfo.sentences![i]
                                          .toString(),
                                      tags: {
                                        'b': StyledTextTag(
                                            style: TextStyle(
                                                color:
                                                    widget.caseInfo.scores![i] >
                                                            0.8
                                                        ? ColorStyles.themeRed
                                                        : Colors.orange,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700))
                                      },
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const Navbar(selectedIndex: 1),
    );
  }
}
