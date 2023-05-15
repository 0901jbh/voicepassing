import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';
import 'package:voicepassing/style/color_style.dart';
import 'package:voicepassing/widgets/indicator.dart';

class PieChartSample2 extends StatefulWidget {
  const PieChartSample2({super.key, required this.data});

  final List data;

  @override
  State<PieChartSample2> createState() => _PieChart2State();
}

class _PieChart2State extends State<PieChartSample2> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 2,
                  centerSpaceRadius: 30,
                  sections: showingSections(widget.data),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Indicator(
                color: ColorStyles.themeRed,
                text: '기관 사칭형',
                isSquare: true,
                size: 12,
              ),
              SizedBox(
                height: 10,
              ),
              Indicator(
                color: ColorStyles.themeLightBlue,
                text: '대출 빙자형',
                isSquare: true,
                size: 12,
              ),
              SizedBox(
                height: 10,
              ),
              Indicator(
                color: ColorStyles.subDarkGray,
                text: '기타 형태',
                isSquare: true,
                size: 12,
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections(data) {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 15.0 : 14.0;
      final radius = isTouched ? 70.0 : 60.0;
      const shadows = [Shadow(color: Colors.white, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: ColorStyles.themeRed,
            value: data[0],
            title: '${data[0].floor()}건',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: ColorStyles.themeLightBlue,
            value: data[1],
            title: '${data[1].floor()}건',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: ColorStyles.textDarkGray,
            value: data[2],
            title: '${data[2].floor()}건',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
