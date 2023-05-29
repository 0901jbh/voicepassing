import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voicepassing/models/receive_message_model.dart';
import 'package:voicepassing/providers/is_analyzing.dart';
import 'package:voicepassing/providers/realtime_provider.dart';
import 'package:voicepassing/style/color_style.dart';
import 'package:voicepassing/widgets/realtime_widget/list_item_widget.dart';
import 'package:voicepassing/widgets/realtime_widget/loading_list_widget.dart';

class RealtimeBodyWidget extends StatefulWidget {
  const RealtimeBodyWidget({super.key});

  @override
  State<RealtimeBodyWidget> createState() => _RealtimeBodyWidgetState();
}

class _RealtimeBodyWidgetState extends State<RealtimeBodyWidget> {
  final ScrollController _scrollController = ScrollController();

  void scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 75,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    RealtimeProvider realtimeProvider = Provider.of<RealtimeProvider>(context);
    List<ReceiveMessageModel> data = context.watch<RealtimeProvider>().realtimeDataList;
    realtimeProvider.addListener(() {
      if (_scrollController.hasClients) {
        scrollToBottom();
      }
    });
    bool isAnalyzing = context.watch<IsAnalyzing>().isAnalyzing;
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
        child: Column(
          children: [
            const Text(
              '분석 결과',
              style: TextStyle(
                color: ColorStyles.textDarkGray,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraint) {
                  return SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraint.maxHeight),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            for (ReceiveMessageModel item in data)
                              if (item.result!.totalCategory >= 1) ...[
                                ListItemWidget(jsonData: item),
                                const SizedBox(height: 12),
                              ],
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease,
                              height: !isAnalyzing && data.isEmpty ? MediaQuery.of(context).size.height - 450 : 0,
                              child: !isAnalyzing && data.isEmpty ? const Center(
                                child: Text(
                                    '정상적인 통화입니다.', 
                                    style: TextStyle(
                                      color: ColorStyles.themeLightBlue, 
                                      fontSize: 15,
                                    ),
                                  ),
                              ) : null,
                            ),
                            AnimatedAlign(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease,
                              alignment: !isAnalyzing && data.isEmpty ? Alignment.bottomCenter : Alignment.topCenter,
                              child: const Column(
                                children: [
                                  LoadingListWidget(),
                                  SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData sampleData() {
    List<Color> gradientColors = [
      ColorStyles.backgroundRed,
      ColorStyles.backgroundYellow,
    ];
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: ColorStyles.newBlue,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: ColorStyles.newBlue,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
