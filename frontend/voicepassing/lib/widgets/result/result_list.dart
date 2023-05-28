import 'package:circle_progress_bar/circle_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:voicepassing/models/result_model.dart';
import 'package:voicepassing/screens/result_screen_detail.dart';
import 'package:voicepassing/style/color_style.dart';

class ResultList extends StatelessWidget {
  final ResultModel caseInfo;

  const ResultList({super.key, required this.caseInfo});

  @override
  Widget build(BuildContext context) {
    Color textColor;
    if (caseInfo.score! >= 0.8 && caseInfo.type! >= 1) {
      textColor = ColorStyles.themeRed;
    } else if (caseInfo.score! >= 0.6 && caseInfo.type! >= 1) {
      textColor = ColorStyles.newYellow;
    } else {
      textColor = ColorStyles.newBlue;
    }
    return GestureDetector(
      onTap: () {
        Get.to(
            () => ResultScreenDetail(
                  resultInfo: caseInfo,
                ),
            transition: Transition.fade);
      },
      child: Container(
          height: 99,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(50),
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(50),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                spreadRadius: 3,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding:
                const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('yyyy/MM/dd')
                            .format(DateTime.parse(caseInfo.date.toString())),
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Expanded(
                              child: Text(
                                caseInfo.words != null
                                    ? caseInfo.words!.join('  ')
                                    : '',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: ColorStyles.textBlack,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ]),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                SizedBox(
                    width: 67,
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
              ],
            ),
          ),
        ),
    );
  }
}
