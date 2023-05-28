import 'package:flutter/material.dart';
import 'package:voicepassing/services/api_service.dart';
import 'package:voicepassing/widgets/pie_chart.dart';

class ChartBox extends StatelessWidget {
  ChartBox({super.key});

  final List<double> tempData = [1, 1, 1];
  final Future<List<double>> categoryNum = ApiService.getCategoryNum();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 5,
        ),
        Container(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 0.1),
                ),
              ],
            ),
            child: FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Stack(children: [
                      Transform.translate(
                          offset: const Offset(-10, 0),
                          child: PieChartSample2(data: snapshot.data!)),
                      Transform.translate(
                          offset: const Offset(160, 20),
                          child: Transform.scale(
                              scale: 1,
                              child: const Text(
                                '최근 범죄 유형',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ))),
                    ]),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              future: categoryNum,
            )),
        const SizedBox(
          height: 26,
        ),
      ],
    );
  }
}
