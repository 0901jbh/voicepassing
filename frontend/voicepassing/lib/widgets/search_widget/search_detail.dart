import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:styled_text/styled_text.dart';
import 'package:voicepassing/models/result_model.dart';
import 'package:voicepassing/services/classify.dart';
import 'package:voicepassing/style/color_style.dart';
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
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          TopTitle(
            phoneNumber: phoneNumber,
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            decoration: const BoxDecoration(
                color: ColorStyles.backgroundBlue,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: SizedBox(
                    child: PieChartSample2(data: categoryNum),
                  ),
                ),
                for (var result in resultList!)
                  listInstances(
                    result: result,
                  )
              ],
            ),
          )
        ],
      ),
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Image.asset(
                'images/empty.png',
                height: 180,
              ),
            ),
            StyledText(
              text: '<b>정보없음</b>',
              tags: {
                'b': StyledTextTag(
                    style: const TextStyle(
                        color: ColorStyles.themeLightBlue,
                        fontSize: 27,
                        fontWeight: FontWeight.w700))
              },
            ),
            const SizedBox(
              height: 10,
            ),
            StyledText(
              text: '<b>$phoneNumber</b>의',
              tags: {
                'b': StyledTextTag(
                    style: const TextStyle(
                        color: ColorStyles.themeLightBlue,
                        fontSize: 22,
                        fontWeight: FontWeight.w500))
              },
            ),
            const SizedBox(
              height: 10,
            ),
            const Text('보이스피싱 이력이 없습니다')
          ],
        ),
      ),
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
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 12, bottom: 12),
                child: Text(DateFormat('yy.M.d').format(datetime),
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 12)),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}

class TopTitle extends StatelessWidget {
  final phoneNumber;

  const TopTitle({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StyledText(
              text: '<b>$phoneNumber</b>의',
              tags: {
                'b': StyledTextTag(
                    style: const TextStyle(
                        color: ColorStyles.themeRed,
                        fontSize: 22,
                        fontWeight: FontWeight.w600))
              },
            ),
            const Text('보이스피싱 이력을'),
            const Text('발견했습니다')
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'images/search_find.png',
              height: 100,
            ),
          ),
        ),
      ],
    );
  }
}
