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
        child: SizedBox(
          height: 90,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 20, top: 12, bottom: 12, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('yy.M.d')
                            .format(DateTime.parse(caseInfo.date.toString())),
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              state,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w700),
                            ),
                            Expanded(
                              child: Text(
                                caseInfo.words != null
                                    ? caseInfo.words!.join(',')
                                    : '',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: ColorStyles.subDarkGray,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ]),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SizedBox(
                    width: 60,
                    child: CircleProgressBar(
                      foregroundColor: textColor,
                      backgroundColor: Colors.transparent,
                      // value/1 표시
                      value: caseInfo.score!,
                      child: Center(
                        child: AnimatedCount(
                          style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 20),
                          fractionDigits: 0,
                          count: caseInfo.score! * 100,
                          unit: '',
                          duration: const Duration(microseconds: 500),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
