import 'package:circle_progress_bar/circle_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voicepassing/models/result_model.dart';
import 'package:voicepassing/screens/result_screen_detail.dart';
import 'package:voicepassing/style/color_style.dart';

class ResultList extends StatelessWidget {
  final ResultModel caseInfo;

  const ResultList({super.key, required this.caseInfo});

  @override
  Widget build(BuildContext context) {
    const roundedRectangleBorder = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(15),
      ),
    );
    Color textColor;
    Color backgroundColor;
    String state;
    if (caseInfo.score! >= 80) {
      textColor = ColorStyles.dangerText;
      backgroundColor = ColorStyles.danger;
      state = '위험 ';
    } else {
      textColor = ColorStyles.warningText;
      backgroundColor = ColorStyles.warning;
      state = '경고 ';
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreenDetail(
              caseInfo: caseInfo,
            ),
          ),
        );
      },
      child: Card(
        shape: roundedRectangleBorder,
        elevation: 0,
        color: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            height: 70,
            width: 300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat('yy.M.d')
                        .format(DateTime.parse(caseInfo.date.toString()))),
                    // Text(
                    //   caseInfo.date.toString(),
                    //   style: const TextStyle(fontWeight: FontWeight.w900),
                    // ),
                    Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text(
                        state,
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w900),
                      ),
                      SizedBox(
                        width: 150,
                        child: Text(
                          caseInfo.words.toString(),
                          style: const TextStyle(color: ColorStyles.grayText),
                        ),
                      ),
                    ]),
                  ],
                ),
                SizedBox(
                  width: 60,
                  child: CircleProgressBar(
                    foregroundColor: textColor,
                    backgroundColor: Colors.transparent,
                    // value/1 표시
                    value: caseInfo.score! / 100,
                    child: Center(
                      child: AnimatedCount(
                        style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                        fractionDigits: 0,
                        count: caseInfo.score!,
                        unit: '',
                        duration: const Duration(microseconds: 500),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
