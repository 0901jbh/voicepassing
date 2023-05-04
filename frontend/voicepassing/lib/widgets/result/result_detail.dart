import 'package:circle_progress_bar/circle_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:voicepassing/models/case_model.dart';
import 'package:voicepassing/style/color_style.dart';
import 'package:voicepassing/widgets/result/double_value_text_with_circle.dart';

class ResultDetailList extends StatelessWidget {
  final CaseModel caseInfo;

  const ResultDetailList({super.key, required this.caseInfo});

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color backgroundColor;
    String state;
    if (caseInfo.score >= 80) {
      textColor = ColorStyles.dangerText;
      backgroundColor = ColorStyles.danger;
      state = '위험 ';
    } else {
      textColor = ColorStyles.warningText;
      backgroundColor = ColorStyles.warning;
      state = '경고 ';
    }
    const roundedRectangleBorder = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(15),
      ),
    );
    return Card(
      shape: roundedRectangleBorder,
      elevation: 0,
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          height: 100,
          width: 300,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    '해당 통화는',
                  ),
                  Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text(
                      '"${caseInfo.type}"',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                          color: textColor),
                    ),
                    const Text('으로'),
                  ]),
                  const Text('의심됩니다')
                ],
              ),
              SizedBox(
                width: 90,
                child: CircleProgress(
                  textColor: textColor,
                  score: caseInfo.score,
                  state: state,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CircleProgress extends StatelessWidget {
  final Color textColor;
  final double score;
  final String state;

  const CircleProgress(
      {super.key,
      required this.textColor,
      required this.score,
      required this.state});
  @override
  Widget build(BuildContext context) {
    return CircleProgressBar(
      foregroundColor: textColor,
      backgroundColor: Colors.transparent,
      strokeWidth: 10,
      // value/1 표시
      value: score / 100,
      child: DoubleValueTextWithCircle(
        txt: state,
        style: TextStyle(
            color: textColor, fontWeight: FontWeight.w500, fontSize: 27),
        fractionDigits: 0,
        count: score,
        unit: '',
        duration: const Duration(microseconds: 500),
      ),
    );
  }
}
