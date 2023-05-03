import 'package:phone_state/phone_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:voicepassing/style/color_style.dart';

class RealTimeResultWidget extends StatefulWidget {
  const RealTimeResultWidget({Key? key}) : super(key: key);

  @override
  State<RealTimeResultWidget> createState() => _RealTimeResultWidgetState();
}

class _RealTimeResultWidgetState extends State<RealTimeResultWidget> {
  Color color = const Color(0xFFFFFFFF);
  String status = 'default';
  List<String> dangerousKeywords = [
    '중앙검찰',
    '송금',
    '대포통장',
  ];

  @override
  void initState() {
    super.initState();
    debugPrint("HELLO");
    setStream();
  }

  void setStream() {
    debugPrint('asdfdsfsdf');
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
    return Material(
      color: Colors.transparent,
      elevation: 0.0,
      child: GestureDetector(
        onTap: () {
          FlutterOverlayWindow.resizeOverlay(320, 80);
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: ColorStyles.dangerText,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(15)),
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
                        const Text(
                          '위험',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        for (var dangerousKeyword in dangerousKeywords)
                          Row(
                            children: [
                              Text(
                                dangerousKeyword,
                                style: const TextStyle(
                                  color: ColorStyles.lightGrayText,
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
                      child: const Text(
                        '96',
                        style: TextStyle(
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
