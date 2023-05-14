import 'package:circle_progress_bar/circle_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:voicepassing/models/result_model.dart';
import 'package:voicepassing/services/classify.dart';
import 'package:voicepassing/style/color_style.dart';
import 'package:voicepassing/widgets/result/double_value_text_with_circle.dart';
import 'package:styled_text/styled_text.dart';

class ResultDetailList extends StatelessWidget {
  final ResultModel caseInfo;

  const ResultDetailList({super.key, required this.caseInfo});

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color backgroundColor;
    String state;
    bool crime = false;
    var category = Classify.getCategory(caseInfo.type as int);
    if (caseInfo.score! >= 0.8 && caseInfo.type! >= 1) {
      textColor = ColorStyles.themeRed;
      backgroundColor = ColorStyles.backgroundRed;
      state = '위험 ';
    } else if (caseInfo.score! >= 0.6 && caseInfo.type! >= 1) {
      textColor = ColorStyles.themeYellow;
      backgroundColor = ColorStyles.backgroundYellow;
      state = '경고 ';
    } else {
      textColor = ColorStyles.themeLightBlue;
      backgroundColor = ColorStyles.backgroundBlue;
      state = '정상 ';
      crime = true;
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('해당 통화는',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: ColorStyles.textDarkGray,
                          fontSize: 15)),
                  Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text(
                      state == "정상 " ? '"정상"' : '"${category['type']}"',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: textColor),
                    ),
                    const Text('으로',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: ColorStyles.textDarkGray,
                            fontSize: 15)),
                  ]),
                  StyledText(
                      text: crime ? '판단됩니다' : '의심됩니다',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: ColorStyles.textDarkGray,
                          fontSize: 15)),
                ],
              ),
              SizedBox(
                width: 90,
                child: CircleProgress(
                  textColor: textColor,
                  score: caseInfo.score!,
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
      value: score,
      child: DoubleValueTextWithCircle(
        txt: state,
        style: TextStyle(
            color: textColor, fontWeight: FontWeight.w500, fontSize: 27),
        fractionDigits: 0,
        count: score * 100,
        unit: '',
        duration: const Duration(microseconds: 500),
      ),
    );
  }
}
