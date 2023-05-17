import 'package:flutter/material.dart';
import 'package:voicepassing/models/receive_message_model.dart';
import 'package:voicepassing/style/color_style.dart';

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
              SizedBox(
                height: 60,
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
                      mainAxisSize: MainAxisSize.max,
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
                        Row(
                          children: [
                            if (resultData.result != null &&
                                resultData.result!.results is List &&
                                resultData.result!.results!.isNotEmpty)
                              for (var item in getKeywords())
                                Row(
                                  children: [
                                    Text(
                                      item,
                                      style: TextStyle(
                                        color: resultData.result != null &&
                                                resultData.result!
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
                        (resultData.result != null
                                ? resultData.result!.totalCategoryScore * 100
                                : 0)
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
