import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:vibration/vibration.dart';
import 'package:voicepassing/models/receive_message_model.dart';
import 'package:voicepassing/style/color_style.dart';

class RealTimeResultWidget extends StatefulWidget {
  const RealTimeResultWidget({Key? key}) : super(key: key);

  @override
  State<RealTimeResultWidget> createState() => _RealTimeResultWidgetState();
}

class _RealTimeResultWidgetState extends State<RealTimeResultWidget> {
  // Color color = const Color(0xFFFFFFFF);
  TotalResult resultData = TotalResult(
    totalCategory: 1,
    totalCategoryScore: 0.5,
    results: [
      ResultItem(
          sentCategory: 1,
          sentCategoryScore: 0.5,
          sentKeyword: '',
          keywordScore: 0.5,
          sentence: ''),
    ],
  );

  @override
  void initState() {
    super.initState();
    FlutterOverlayWindow.overlayListener.listen((newResult) {
      setState(() {
        resultData = TotalResult.fromJson(newResult);
        debugPrint('점수 : ${resultData.totalCategoryScore * 100}');
        FlutterOverlayWindow.resizeOverlay(320, 80);
        Vibration.vibrate();
      });
    });
    // setStream();
  }

  // void setStream() {
  //   debugPrint('알림 위젯 setStream');
  //   PhoneState.phoneStateStream.listen((event) {
  //     if (event == PhoneStateStatus.CALL_STARTED) {
  //       debugPrint('전화 이벤트 : $event');
  //       setState(() {
  //         FlutterOverlayWindow.resizeOverlay(320, 80);
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0.0,
      child: GestureDetector(
        child: Container(
          height: 80,
          width: 320,
          decoration: BoxDecoration(
            color: resultData.totalCategoryScore * 100 > 80
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
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          resultData.totalCategoryScore * 100 > 80
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
                              resultData.results![0].sentKeyword,
                              style: TextStyle(
                                color: resultData.totalCategoryScore * 100 > 80
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
                        (resultData.totalCategoryScore * 100)
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
    );
  }
}
