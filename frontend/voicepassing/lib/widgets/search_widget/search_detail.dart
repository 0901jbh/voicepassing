import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:voicepassing/models/result_model.dart';
import 'package:voicepassing/services/classify.dart';
import 'package:voicepassing/style/color_style.dart';
import 'package:voicepassing/style/shadow_style.dart';
import 'package:voicepassing/widgets/pie_chart.dart';

class SearchDetail extends StatelessWidget {
  String phoneNumber;
  final List<ResultModel>? resultList;

  SearchDetail(
      {super.key, required this.phoneNumber, required this.resultList});

  // 임시데이터
  List<double> categoryNum = [0, 0, 0, 0];

  @override
  Widget build(BuildContext context) {
    String digitsOnly = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length == 10) {
      phoneNumber = digitsOnly.replaceFirstMapped(
          RegExp(r'^(\d{2})(\d{4})(\d{4})$'),
          (match) => '${match[1]}-${match[2]}-${match[3]}');
    } else if (digitsOnly.length == 11) {
      phoneNumber = digitsOnly.replaceFirstMapped(
          RegExp(r'^(\d{3})(\d{4})(\d{4})$'),
          (match) => '${match[1]}-${match[2]}-${match[3]}');
    }
    if (resultList == null) {
      return EmptyContent(phoneNumber: phoneNumber);
    }
    for (ResultModel result in resultList!) {
      if (result.type! > 0) {
        categoryNum[(result.type as int) - 1] += 1;
      } else {
        categoryNum[3] += 1;
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
              boxShadow: [ShadowStyle.wideShadow],
            ),
            child: Column(
              children: [
                Transform.scale(
                  scale: 0.95,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: PieChartSample2(data: categoryNum),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          '보이스피싱 이력',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(
          height: 15,
        ),
        for (var result in resultList!)
          listInstances(
            result: result,
          )
      ],
    );
  }
}

class EmptyContent extends StatelessWidget {
  const EmptyContent({
    super.key,
    required this.phoneNumber,
  });

  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [ShadowStyle.wideShadow],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 55),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    MdiIcons.clipboardTextSearch,
                    size: 95,
                    color: ColorStyles.newBlue,
                  ),
                  Column(
                    children: [
                      Text(
                        phoneNumber,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: ColorStyles.newBlue),
                      ),
                      const Text('검색결과 없음',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}

class listInstances extends StatelessWidget {
  final ResultModel result;

  const listInstances({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    late DateTime datetime;
    var info = Classify.getCategory(result.type as int);
    if (result.date != null) {
      datetime = DateTime.parse(result.date.toString());
    } else {
      datetime = DateTime.now();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 10, left: 2, right: 2),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [ShadowStyle.wideShadow],
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 15),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(DateFormat('yyyy/MM/d').format(datetime),
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 12)),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        info['type'],
                        style: TextStyle(
                            color: info['color'],
                            fontWeight: FontWeight.w700,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
