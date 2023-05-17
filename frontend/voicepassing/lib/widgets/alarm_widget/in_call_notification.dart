import 'package:flutter/material.dart';
import 'package:voicepassing/models/receive_message_model.dart';
import 'package:voicepassing/style/color_style.dart';
import 'package:voicepassing/widgets/realtime_widget/realtime_circle_progress_bar.dart';

class InCallNotification extends StatelessWidget {
  const InCallNotification({
    super.key,
    required this.resultData,
  });

  final ReceiveMessageModel resultData;

  List<String> getKeywords() {
    List<String> keywords = [];
    if (resultData.result != null &&
        resultData.result!.results != null &&
        resultData.result!.results!.isNotEmpty) {
      var rawData = resultData.result!.results!;
      rawData
          .sort((a, b) => a.sentCategoryScore.compareTo(b.sentCategoryScore));
      if (rawData.length > 3) {
        for (var item in rawData.sublist(0, 3)) {
          keywords.add(item.sentKeyword);
        }
      } else {
        for (var item in rawData) {
          keywords.add(item.sentKeyword);
        }
      }
    }
    return keywords;
  }

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
            color: resultData.result != null &&
                    resultData.result!.totalCategoryScore * 100 > 80
                ? ColorStyles.themeRed
                : ColorStyles.themeYellow,
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // ignore: prefer_const_constructors
                    Row(
                      children: const [
                        Image(
                          image: AssetImage('images/VoiceLogo.png'),
                          height: 22,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          resultData.result != null &&
                                  resultData.result!.totalCategoryScore * 100 >
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
                        Expanded(
                          child: Text(
                            resultData.result!.totalCategory == 1
                                ? '기관사칭형 보이스피싱'
                                : resultData.result!.totalCategory == 2
                                    ? '대출빙자형 보이스피싱'
                                    : '기타유형  보이스피싱',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: resultData.result != null &&
                                      resultData.result!.totalCategoryScore *
                                              100 >
                                          80
                                  ? ColorStyles.subLightGray
                                  : ColorStyles.textBlack,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 60,
                child: RealtimeCircleProgressBar(
                  textColor: Colors.white,
                  score: resultData.result!.totalCategoryScore as double,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
