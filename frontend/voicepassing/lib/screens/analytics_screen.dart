import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';
import 'package:voicepassing/screens/main_screen.dart';
import 'package:voicepassing/widgets/head_bar.dart';
import 'package:voicepassing/widgets/nav_bar.dart';

import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';

import 'package:voicepassing/models/result_model.dart';
import 'dart:convert';
import 'package:voicepassing/screens/result_screen_detail.dart';
import 'package:voicepassing/screens/result_screen_detail_ok.dart';
import 'package:voicepassing/style/color_style.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _ResultScreenState();
}

// Todo: 임시로 넣어놓은 데이터, 삭제예정
class _ResultScreenState extends State<AnalyticsScreen> {
  String? _filePath;
  String result = "a";
  int counter = 0;
  bool isSend = false;
  Future<void> _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _filePath = result.files.single.path;
        counter = counter + 1;
        isSend = true;
      });
    }
    _Dio();
  }

  void _Dio() async {
    final file = File(_filePath!);
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
    });
    print("before response");
    final response = await Dio().post(
      //'http://10.0.2.2:8080/api/analysis/file',
      'http://k8a607.p.ssafy.io:8080/api/analysis/file',
      data: formData,
    );
    final jsonString = jsonEncode(response.data);
    final json = jsonDecode(jsonString);
    final resultModel = ResultModel.fromJson(json);
    isSend = false;
    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResultScreenDetail(
                  caseInfo: resultModel,
                )),
      );
    }
    if (response.statusCode == 201) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResultScreenDetailOK(
                  caseInfo: resultModel,
                )),
      );
    }

    setState(() {
      result = response.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeadBar(
        navPage: MainScreen(),
        title: const Text(
          '녹음 파일 검사',
          style: TextStyle(
            fontSize: 18.0,
            color: ColorStyles.textBlack,
          ),
        ),
        appBar: AppBar(),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  //const TopTitle(),
                  SizedBox(
                    width: 230,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StyledText(
                              text: '<b>통화 음성 파일</b>을',
                              tags: {
                                'b': StyledTextTag(
                                    style: const TextStyle(
                                        color: ColorStyles.themeLightBlue,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700))
                              },
                              style: const TextStyle(
                                color: ColorStyles.textDarkGray,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            StyledText(
                                text: isSend ? '분석 중 입니다' : '검사할 수 있습니다',
                                style: const TextStyle(
                                  color: ColorStyles.textDarkGray,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Image.asset(
                          !isSend
                              ? 'images/AnalyticstitleImg.png'
                              : 'images/AnalyticsImg.png',
                          height: 101,
                          width: 79,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Visibility(
                    visible: !isSend,
                    child: ElevatedButton(
                      onPressed: _openFilePicker,
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.all(0)),
                      ),
                      child: Image.asset(
                        'images/FileButton.png',
                        height: 150,
                        width: 150,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isSend,
                    child: const SizedBox(
                      height: 40,
                    ),
                  ),

                  Visibility(
                    visible: isSend,
                    child: const SizedBox(
                      child: CircularProgressIndicator(
                        strokeWidth: 15,
                        backgroundColor: Colors.black,
                        color: ColorStyles.themeLightBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const Navbar(selectedIndex: 4),
      // bottomNavigationBar: const Navbar(),
    );
  }
}
