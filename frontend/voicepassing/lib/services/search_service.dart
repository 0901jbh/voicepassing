import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voicepassing/services/api_service.dart';
import 'package:voicepassing/widgets/search_widget/search_detail.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({
    super.key,
  });

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final myController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    // 텍스트에디팅컨트롤러를 제거하고, 등록된 리스너도 제거된다.
    myController.dispose();
    super.dispose();
  }

  // myController의 텍스트를 콘솔에 출력하는 메소드
  void _printLatestValue() {}

  late var caseInfo;
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                        width: 180,
                        height: 50,
                        child: Card(
                            color: Colors.blue,
                            child: TextField(
                              textInputAction: TextInputAction.go,
                              onSubmitted: (value) async {
                                caseInfo =
                                    await ApiService.getPhoneNumber(value);
                                print(caseInfo);
                                setState(() {
                                  hasData = true;
                                  print('15');
                                  print(hasData);
                                });
                                //Todo: 전화번호인지 확인하는 로직 나중에 추가할것
                              },
                              controller: myController,
                              onChanged: (value) {
                                setState(() {
                                  textValue = value;
                                });
                              },
                              autofocus: true,
                              decoration: InputDecoration(
                                suffixIconConstraints: const BoxConstraints(
                                  maxHeight: 20,
                                  maxWidth: 20,
                                ),
                                suffixIcon: Padding(
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
                                          ),
                                        )
                                      : null,
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                )),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(15),
              ),
              child: GestureDetector(
                  onTap: () async {
                    ClipboardData? data =
                        await Clipboard.getData(Clipboard.kTextPlain);
                    String str = data?.text ?? '';

                    if (str.isNotEmpty) {
                      myController.text = (str);
                    }
                    // print(data);
                    // print(data?.text);
                    // print('눌값?');
                  },
                  child: const Icon(
                    Icons.paste_sharp,
                    color: Colors.white,
                  )),
            )
          ],
        ),
        // hasData
        //     ? SingleChildScrollView(child: Text(caseInfo.toString()))
        //     : const Text('데이터없음')
        const SearchDetail()
      ],
    );
  }
}
