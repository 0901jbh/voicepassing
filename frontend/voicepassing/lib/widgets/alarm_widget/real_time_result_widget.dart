import 'dart:math';

import 'package:phone_state/phone_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:provider/provider.dart';
import 'package:voicepassing/models/receive_message_model.dart';
import 'package:voicepassing/providers/real_time_result.dart';
import 'package:voicepassing/style/color_style.dart';

class RealTimeResultWidget extends StatefulWidget {
  const RealTimeResultWidget({Key? key}) : super(key: key);

  @override
  State<RealTimeResultWidget> createState() => _RealTimeResultWidgetState();
}

class _RealTimeResultWidgetState extends State<RealTimeResultWidget> {
  Color color = const Color(0xFFFFFFFF);
  String status = 'default';
  late List<String> dangerousKeywords = [
    '중앙검찰',
    '송금',
    '대포통장',
  ];
  double score = 50;

  @override
  void initState() {
    super.initState();
    setStream();
  }

  void setStream() {
    debugPrint('알림 위젯 setStream');
    PhoneState.phoneStateStream.listen((event) {
      if (event == PhoneStateStatus.CALL_STARTED) {
        debugPrint('전화 이벤트 : $event');
        setState(() {
          status = 'danger';
          FlutterOverlayWindow.resizeOverlay(320, 80);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => RealTimeResult(),
      child: Material(
        color: Colors.transparent,
        elevation: 0.0,
        child: GestureDetector(
          onTap: () {
            FlutterOverlayWindow.resizeOverlay(320, 80);
            TotalResult newResult = TotalResult(
              totalCategory: -1,
              totalCategoryScore: -1,
              results: [
                ResultItem(
                  sentCategory: Random().nextInt(3) + 1,
                  sentCategoryScore: Random().nextInt(60) + 40,
                  sentKeyword: '녹취',
                  keywordScore: Random().nextInt(60) + 40,
                  sentence: 'sentence',
                ),
              ],
            );
            // context.read<RealTimeResult>().update(newResult);
          },
          child: Container(
            height: 80,
            width: 320,
            decoration: BoxDecoration(
              color: context.watch<RealTimeResult>().result.totalCategoryScore *
                          100 >
                      80
                  ? ColorStyles.dangerText
                  : ColorStyles.warningText,
              shape: BoxShape.rectangle,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Row(
                        children: [
                          Image(
                            image: AssetImage('images/VoiceLogo.png'),
                            height: 22,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '검사',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            context
                                            .watch<RealTimeResult>()
                                            .result
                                            .totalCategoryScore *
                                        100 >
                                    80
                                ? '위험'
                                : '주의',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                context
                                    .watch<RealTimeResult>()
                                    .result
                                    .results![0]
                                    .sentKeyword,
                                style: TextStyle(
                                  color: context
                                                  .watch<RealTimeResult>()
                                                  .result
                                                  .totalCategoryScore *
                                              100 >
                                          80
                                      ? ColorStyles.subLightGray
                                      : ColorStyles.textBlack,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 60,
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 5,
                            color: Colors.white,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          (context
                                      .watch<RealTimeResult>()
                                      .result
                                      .totalCategoryScore *
                                  100)
                              .round()
                              .toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
