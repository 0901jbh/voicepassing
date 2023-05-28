import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:voicepassing/models/result_model.dart';
import 'package:voicepassing/services/api_service.dart';
import 'package:voicepassing/style/color_style.dart';
import 'package:voicepassing/widgets/search_widget/search_detail.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({
    super.key,
  });

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  late FocusNode myFocusNode;
  final myController = TextEditingController();
  String phoneNumber = '';
  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    myController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    // 텍스트에디팅컨트롤러를 제거하고, 등록된 리스너도 제거된다.
    myController.dispose();
    myFocusNode.dispose();
    super.dispose();
  }

  // myController의 텍스트를 콘솔에 출력하는 메소드
  void _printLatestValue() {}

  late List<ResultModel>? caseInfo;
  void setText(String txt) {
    setState(() {
      String mytext = myController.text;
      myController.text = txt;
    });
  }

  bool hasData = false;
  @override
  Widget build(BuildContext context) {
    String textValue = myController.text;
    bool showSuffixIcon = textValue.isNotEmpty;
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Hero(
                tag: 'searchBar',
                child: Material(
                  child: Container(
                      height: 34,
                      decoration: BoxDecoration(
                        color: ColorStyles.newBlue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: Row(
                          textBaseline: TextBaseline.alphabetic,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Transform.translate(
                                offset: const Offset(0, 5),
                                child: TextField(
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      hintText: '전화번호를 입력하세요',
                                      hintStyle:
                                          TextStyle(color: Colors.white)),
                                  focusNode: myFocusNode,
                                  textInputAction: TextInputAction.go,
                                  onSubmitted: (value) async {
                                    caseInfo =
                                        await ApiService.getPhoneNumber(value);
                                    setState(() {
                                      phoneNumber = value;
                                      hasData = true;
                                    });
                                  },
                                  controller: myController,
                                  onChanged: (value) {
                                    setState(() {
                                      textValue = value;
                                    });
                                  },
                                  autofocus: true,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: showSuffixIcon
                                    ? IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          setState(() {
                                            myController.clear();
                                            textValue = '';
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.cancel,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(
                color: ColorStyles.newBlue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: GestureDetector(
                  onTap: () async {
                    FlutterClipboard.paste().then((value) {
                      myController.text = value;
                      setState(() {});
                    });
                  },
                  child: const Icon(
                    Icons.paste_sharp,
                    color: Colors.white,
                    size: 17,
                  )),
            )
          ],
        ),
        phoneNumber.isNotEmpty
            ? Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          '검색결과',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                        SearchDetail(
                          phoneNumber: phoneNumber,
                          resultList: caseInfo,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const Text('')
      ],
    );
  }
}
