import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';
import 'package:voicepassing/screens/main_screen.dart';
import 'package:voicepassing/services/api_service.dart';

class MainLogo extends StatelessWidget {
  final Future caseNum = ApiService.getCaseNum();

  MainLogo({
    super.key,
    required this.widget,
  });

  final MainScreen widget;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: caseNum,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return SizedBox(
              width: 315,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StyledText(
                        text: '오늘 <b>보이스패싱</b>은',
                        tags: {
                          'b': StyledTextTag(
                              style: const TextStyle(color: Colors.blue))
                        },
                      ),
                      StyledText(
                        text: '<b>${snapshot.data['resultNum']}건</b>을',
                        tags: {
                          'b': StyledTextTag(
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 30))
                        },
                      ),
                      const Text('잡았어요')
                    ],
                  ),
                  Image.asset(
                    'images/MainImg.png',
                    height: 110,
                  )
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
