import 'package:flutter/material.dart';

import 'package:voicepassing/models/result_model.dart';

import 'package:voicepassing/widgets/nav_bar.dart';
import 'package:voicepassing/widgets/result/result_detail.dart';

import 'package:intl/intl.dart';
//import 'package:voicepassing/widgets/head_bar.dart';

import 'package:voicepassing/widgets/head_bar_no_rewind.dart';

class ResultScreenDetailOK extends StatefulWidget {
  final ResultModel caseInfo;
  const ResultScreenDetailOK({super.key, required this.caseInfo});

  @override
  State<ResultScreenDetailOK> createState() => _ResultScreenDetailOKState();
}

class _ResultScreenDetailOKState extends State<ResultScreenDetailOK> {
  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < widget.caseInfo.sentences!.length; i++) {
      for (String word in widget.caseInfo.words!) {
        widget.caseInfo.sentences![i] =
            widget.caseInfo.sentences![i].replaceAll(word, '<b>$word</b>');
      }
    }
    return Scaffold(
      appBar: HeadBar(
        title: Text(DateFormat('yy.M.d')
            .format(DateTime.parse(widget.caseInfo.date.toString()))),
        appBar: AppBar(),
      ),
      body: Builder(
        builder: (BuildContext context) {
          const roundedRectangleBorder = RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          );
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 24),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 29,
                    ),
                    const Text(
                      '범죄 유형',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ResultDetailList(
                      caseInfo: widget.caseInfo,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Image.asset(
                      'images/result_ok.png',
                      height: 300,
                      width: 400,
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const Navbar(selectedIndex: 1),
    );
  }
}
