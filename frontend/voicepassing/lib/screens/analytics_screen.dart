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
      'http://10.0.2.2:8080/api/analysis/file',
      data: formData,
    );
    final jsonString = jsonEncode(response.data);
    final json = jsonDecode(jsonString);
    final resultModel = ResultModel.fromJson(json);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ResultScreenDetail(
                caseInfo: resultModel,
              )),
    );

    setState(() {
      result = response.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeadBar(
        navPage: MainScreen(),
        title: const Text('녹음 파일 검사'),
        appBar: AppBar(),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Center(
            child: Container(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  //const TopTitle(),
                  SizedBox(
                    width: 330,
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
                                        color: Colors.blue,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600))
                              },
                            ),
                            Text(isSend ? '검사 중 입니다' : '검사할 수 있습니다'),
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
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                    onPressed: _openFilePicker,
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.all(0)),
                    ),
                    child: Image.asset(
                      !isSend
                          ? 'images/FileButton.png'
                          : 'images/VoiceLogo.png',
                      height: 200,
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

class TopTitle extends StatelessWidget {
  const TopTitle({
    super.key,
  });

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
                text: '<b>통화 음성 파일</b>을',
                tags: {
                  'b': StyledTextTag(
                      style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 22,
                          fontWeight: FontWeight.w600))
                },
              ),
              const Text('검사할 수 있습니다.'),
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
