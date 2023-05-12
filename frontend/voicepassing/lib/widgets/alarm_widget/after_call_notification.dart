import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:intl/intl.dart';
import 'package:voicepassing/models/receive_message_model.dart';
import 'package:voicepassing/style/color_style.dart';
import 'package:voicepassing/widgets/alarm_widget/in_call_notification.dart';

class AfterCallNotification extends StatefulWidget {
  const AfterCallNotification({
    super.key,
    required this.resultData,
    required this.phoneNumber,
  });

  final ReceiveMessageModel resultData;
  final String phoneNumber;

  @override
  State<AfterCallNotification> createState() => _AfterCallNotificationState();
}

class _AfterCallNotificationState extends State<AfterCallNotification> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0.0,
      child: GestureDetector(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: widget.resultData.result!.totalCategoryScore >= 0.7
                ? ColorStyles.backgroundRed
                : ColorStyles.backgroundYellow,
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          padding: const EdgeInsets.fromLTRB(8, 6, 8, 12),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                width: 320,
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      DateFormat('a h:mm').format(DateTime.now()),
                      style: const TextStyle(
                        color: ColorStyles.textBlack,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        FlutterOverlayWindow.closeOverlay();
                      },
                      child: const Text(
                        '닫기',
                        style: TextStyle(
                          color: ColorStyles.textBlack,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              InCallNotification(resultData: widget.resultData),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(12),
                ),
                width: 320,
                height: 80,
                padding: const EdgeInsets.fromLTRB(36, 15, 36, 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.phoneNumber,
                          style: const TextStyle(
                            color: ColorStyles.themeRed,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        const Text(
                          '피싱 범죄 이력',
                          style: TextStyle(
                            color: ColorStyles.textDarkGray,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          '??건', // api 연결하기
                          style: TextStyle(
                            color: ColorStyles.textBlack,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: 320,
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        // 번호 차단 기능 연결
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.white70;
                          }
                          return Colors.white;
                        }),
                        overlayColor: MaterialStateProperty.resolveWith(
                            (states) => ColorStyles.themeRed.withOpacity(0.35)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        fixedSize:
                            MaterialStateProperty.all(const Size(153, 40)),
                      ),
                      child: const Text(
                        '차단하기',
                        style: TextStyle(
                          color: ColorStyles.themeRed,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // 검사 결과 상세 페이지로 연결
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.white70;
                          }
                          return Colors.white;
                        }),
                        overlayColor: MaterialStateProperty.resolveWith(
                            (states) =>
                                ColorStyles.subLightGray.withOpacity(0.45)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        fixedSize:
                            MaterialStateProperty.all(const Size(153, 40)),
                      ),
                      child: const Text(
                        '상세보기',
                        style: TextStyle(
                          color: ColorStyles.textBlack,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
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
