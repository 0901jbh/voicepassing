import 'package:flutter/material.dart';
import 'package:voicepassing/style/color_style.dart';
import 'package:voicepassing/widgets/pie_chart.dart';

class ChartBox extends StatelessWidget {
  const ChartBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "범죄 유형 통계",
          textAlign: TextAlign.start,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: ColorStyles.backgroundBlue),
          child: const PieChartSample2(),
        ),
      ],
    );
  }
}
