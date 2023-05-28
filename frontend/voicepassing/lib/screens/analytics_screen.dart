import 'package:flutter/material.dart';
import 'package:get/get.dart' as ggg;
import 'package:styled_text/styled_text.dart';
import 'package:voicepassing/screens/main_screen.dart';
import 'package:voicepassing/widgets/nav_bar.dart';

import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';

import 'package:voicepassing/models/result_model.dart';
import 'dart:convert';
import 'package:voicepassing/screens/result_screen_detail.dart';
import 'package:voicepassing/style/color_style.dart';
import 'package:unique_device_id/unique_device_id.dart';
import 'package:voicepassing/widgets/new_head_bar.dart';

//import 'package:easy_folder_picker/FolderPicker.dart';
//import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

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
  late String androidId;
  Directory selectedDirectory = Directory.current;
  String myText = 'empty';
  @override
  void initState() {
    super.initState();
    initializer();
  }

  void initializer() async {
    androidId = await UniqueDeviceId.instance.getUniqueId() ?? '';
    isSend = false;
    _filePath = "path";
  }

  Future<void> _pickDirectory() async {
    Directory directory = Directory("/storage/emulated/0/Recordings/Call");

    //Directory directory = Directory("/data/data/com.example.voicepassing");

    List<FileSystemEntity> files = directory.listSync();

    flutterDialog(files);
    //callDio();
  }

  void flutterDialog(List<FileSystemEntity> files) {
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: const Column(
              children: <Widget>[
                Text("통화 녹음 목록"),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              height: 400.0, // 원하는 높이로 조정
              child: ListView.builder(
                itemCount: files.length,
                itemBuilder: (context, index) {
                  FileSystemEntity file = files[index];
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _filePath = file.path;
                        counter = counter + 1;
                        isSend = true;
                        _Dio();
                        Navigator.pop(context);
                      });
                    },
                    child: Text(path
                        .basename(file.path)
                        .replaceAll("통화 녹음", "")
                        .trim()),
                  );
                },
              ),
            ),

            actions: <Widget>[
              TextButton(
                child: const Text("확인"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Future<void> _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['xlsx', 'm4a', 'mp3']);
    if (result != null) {
      setState(() {
        _filePath = result.files.single.path;
        counter = counter + 1;
        isSend = true;
      });
      print("print path");
      print(_filePath);
    }
    _Dio();
  }

  void _Dio() async {
    final file = File(_filePath!);
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
      'androidId': androidId,
    });
    final response = await Dio().post(
      'http://k8a607.p.ssafy.io:8080/api/analysis/file',
      data: formData,
    );
    final jsonString = jsonEncode(response.data);
    final json = jsonDecode(jsonString);
    final resultModel = ResultModel.fromJson(json);
    //isSend = false;
    if (response.statusCode == 200 || response.statusCode == 201) {
      ggg.Get.to(
          () => ResultScreenDetail(
                resultInfo: resultModel,
              ),
          transition: ggg.Transition.fade);
    }
    // if (response.statusCode == 201) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => ResultScreenDetailOK(
    //               caseInfo: resultModel,
    //             )),
    //   );
    // }

    setState(() {
      result = response.toString();
    });
  }

  void callDio() {
    _Dio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NewHeadBar(
        navPage: MainScreen(),
        name: 'analytics',
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
                    height: 70,
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
                        height: 200,
                        width: 200, //200 , 200
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isSend,
                    child: const SizedBox(
                      height: 70,
                    ),
                  ),
                  Visibility(
                    visible: isSend,
                    child: const SizedBox(
                      child: CircularProgressIndicator(
                        strokeWidth: 18,
                        backgroundColor: Colors.black,
                        color: ColorStyles.themeLightBlue,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !isSend,
                    child: ElevatedButton(
                      onPressed: _pickDirectory,
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.all(0)),
                      ),
                      child: Image.asset(
                        'images/FileButton.png',
                        height: 200,
                        width: 200,
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
    );
  }
}
