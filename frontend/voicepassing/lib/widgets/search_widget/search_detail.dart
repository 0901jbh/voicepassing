import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';
import 'package:voicepassing/style/color_style.dart';
import 'package:voicepassing/widgets/pie_chart.dart';

class SearchDetail extends StatelessWidget {
  const SearchDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 50,
        ),
        const TopTitle(
          phoneNumber: "010-0000-8888",
        ),
        Container(
          decoration: const BoxDecoration(
              color: ColorStyles.backgroundBlue,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          width: 320,
          child: Column(
            children: const [
              SizedBox(
                child: PieChartSample2(),
              )
            ],
          ),
        )
      ],
    );
  }
}

class TopTitle extends StatelessWidget {
  final phoneNumber;

  const TopTitle({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 330,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StyledText(
                text: '<b>$phoneNumber</b>의',
                tags: {
                  'b': StyledTextTag(
                      style: const TextStyle(
                          color: ColorStyles.dangerText,
                          fontSize: 22,
                          fontWeight: FontWeight.w600))
                },
              ),
              const Text('보이스피싱 이력을'),
              const Text('발견했습니다')
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'images/AnalyticstitleImg.png',
              height: 100,
            ),
          )
        ],
      ),
    );
  }
}
