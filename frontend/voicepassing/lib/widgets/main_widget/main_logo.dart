import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';
import 'package:voicepassing/screens/main_screen.dart';
import 'package:voicepassing/services/api_service.dart';
import 'package:voicepassing/style/color_style.dart';

class MainLogo extends StatelessWidget {
  final Future caseNum = ApiService.getCaseNum();

  MainLogo({
    super.key,
    required this.widget,
  });

  final MainScreen widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 5,
          child: Container(
            child: FutureBuilder(
                future: caseNum,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StyledText(
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                            text: '<b>보이스패싱</b>은',
                            tags: {
                              'b': StyledTextTag(
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: ColorStyles.themeLightBlue))
                            },
                          ),
                          StyledText(
                            style: const TextStyle(fontSize: 18),
                            text: '<b>모두 ${snapshot.data['resultNum']}건</b>을',
                            tags: {
                              'b': StyledTextTag(
                                  style: const TextStyle(
                                      color: ColorStyles.themeBlue,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 24))
                            },
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            '잡았어요',
                            style: TextStyle(
                              fontSize: 18,
                              // fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  return const CircularProgressIndicator();
                }),
          ),
        ),
        Flexible(
          flex: 3,
          child: Image.asset(
            'images/MainImg.png',
          ),
        )
      ],
    );
  }
}
