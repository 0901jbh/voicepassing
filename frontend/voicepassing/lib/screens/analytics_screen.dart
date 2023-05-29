import 'package:flutter/material.dart';
import 'package:get/get.dart' as ggg;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:styled_text/styled_text.dart';
import 'package:voicepassing/screens/main_screen.dart';
import 'package:voicepassing/style/shadow_style.dart';
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
            title: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: StyledText(
                    text: '통화 파일 선택',
                    style: const TextStyle(
                      color: ColorStyles.newBlue,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: StyledText(
                    text: '녹음한 통화 파일을 검사할 수 있습니다',
                    style: const TextStyle(
                      color: ColorStyles.textDarkGray,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              height: 400.0, // 원하는 높이로 조정
              child: ListView.builder(
                itemCount: files.length,
                itemBuilder: (context, index) {
                  files.sort((a, b) {
                    List<String> aParts = path.basename(a.path).split('_');
                    List<String> bParts = path.basename(b.path).split('_');
                    int sizeA = int.parse(aParts[1]);
                    int sizeB = int.parse(bParts[1]);

                    if (sizeA == sizeB) {
                      String timeA =
                          aParts[2].substring(0, aParts[2].length - 4);
                      String timeB =
                          bParts[2].substring(0, bParts[2].length - 4);
                      return timeB.compareTo(timeA);
                    } else {
                      return sizeB.compareTo(sizeA);
                    }
                  });

                  FileSystemEntity file = files[index];
                  List<String> list = path
                      .basename(file.path)
                      .replaceAll("통화 녹음", "")
                      .trim()
                      .split('_');

                  String onlyPath = list[0];
                  String bValue = list[1];

                  String date =
                      '${bValue.substring(0, 2)}.${bValue.substring(2, 4)}.${bValue.substring(4, 6)}';
                  int l = list[2].length;
                  String cValue = list[2].substring(0, l - 4);

                  int hours = int.parse(cValue.substring(0, 2));
                  int minutes = int.parse(cValue.substring(2, 4));
                  int seconds = int.parse(cValue.substring(4, 6));

                  String period = (hours >= 12) ? '오후' : '오전';
                  hours = (hours > 12) ? hours - 12 : hours;

                  String time =
                      '$period ${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // 버튼의 뒷 배경 색을 흰색으로 설정
                    ),
                    onPressed: () {
                      setState(() {
                        _filePath = file.path;
                        counter = counter + 1;
                        isSend = true;
                        _Dio();
                        Navigator.pop(context);
                      });
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          'images/phone.png',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                onlyPath,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: [
                                  Text(
                                    date,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const Text("  "),
                                  Text(
                                    time,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            actions: <Widget>[
              Container(
                height: 2,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  child: StyledText(
                    text: '확인',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
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
      backgroundColor: isSend
          ? const Color.fromARGB(255, 255, 255, 255)
          : const Color(0xffFAFBFC),
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
                  // 1. 파일선택화면 !issend
                  Visibility(
                    visible: !isSend,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 40,
                        ),

                        Image.asset(
                          'images/analytics.gif',
                          fit: BoxFit.fitWidth,
                        ),
                        StyledText(
                          text: '실시간 통화 분석과 동일한\n <b>AI서비스를</b> 제공합니다',
                          style: const TextStyle(
                            color: ColorStyles.textBlack,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                          tags: {
                            'b': StyledTextTag(
                                style: const TextStyle(
                                    color: ColorStyles.newBlue,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700))
                          },
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        BigButton2(
                          icon: Icons.mic,
                          headText: '통화 파일 검사',
                          subText: '녹음한 통화 파일을 검사할 수 있습니다',
                          action: _pickDirectory,
                          type: 1,
                        )
                        // 모든파일검사
                        ,
                        const SizedBox(
                          height: 28,
                        ),
                        BigButton2(
                          icon: MdiIcons.folderOpenOutline,
                          headText: '기기 파일 검사',
                          subText: '기기 전체에서 파일을 찾을 수 있습니다',
                          action: _openFilePicker,
                          type: 2,
                        ),
                        // ElevatedButton(
                        //   onPressed: _pickDirectory,
                        //   style: ButtonStyle(
                        //     padding: MaterialStateProperty.all<EdgeInsets>(
                        //         const EdgeInsets.all(0)),
                        //   ),
                        //   child: Image.asset(
                        //     'images/FileButton.png',
                        //     height: 200,
                        //     width: 200,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  // 2. 로딩화면 issend
                  Visibility(
                    visible: isSend,
                    child: const SizedBox(
                      height: 50,
                    ),
                  ),
                  Visibility(
                    visible: isSend,
                    child: SizedBox(
                      child: Image.asset(
                        'images/waiting.gif',
                        height: 330,
                        width: 330,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isSend,
                    child: StyledText(
                      text: 'AI 분석중',
                      style: const TextStyle(
                        color: ColorStyles.themeLightBlue,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const Navbar(selectedIndex: 2),
    );
  }
}

class BigButton2 extends StatelessWidget {
  final IconData icon;
  final String headText;
  final String subText;
  final VoidCallback? action;
  final int type;

  const BigButton2(
      {super.key,
      required this.icon,
      required this.headText,
      required this.subText,
      this.action,
      required this.type});

  @override
  Widget build(BuildContext context) {
    Color bgcolor;
    Color ctcolor;
    if (type == 1) {
      bgcolor = ColorStyles.newBlue;
      ctcolor = Colors.white;
    } else {
      bgcolor = Colors.white;
      ctcolor = ColorStyles.newBlue;
    }
    return GestureDetector(
      onTap: action,
      child: Container(
        height: 110,
        decoration: BoxDecoration(
            color: bgcolor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [ShadowStyle.wideShadow]),
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                size: 60,
                color: ctcolor,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    headText,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: ctcolor,
                        fontSize: 30),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    subText,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: ctcolor,
                        fontSize: 12),
                  )
                ],
              )
            ],
          ),
        )),
      ),
    );
  }
}
