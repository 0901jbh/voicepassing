import 'package:flutter/material.dart';
import 'package:voicepassing/models/receive_message_model.dart';
import 'package:voicepassing/style/color_style.dart';
import 'package:voicepassing/widgets/realtime_widget/realtime_circle_progress_bar.dart';

class ListItemWidget extends StatelessWidget {
  const ListItemWidget({super.key, required this.jsonData});
  final ReceiveMessageModel jsonData;

  @override
  Widget build(BuildContext context) {
    List<String> getKeywords() {
      List<String> keywords = [];
      if (jsonData.result != null &&
          jsonData.result!.results != null &&
          jsonData.result!.results!.isNotEmpty) {
        var rawData = jsonData.result!.results!;
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

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      width: MediaQuery.of(context).size.width,
      height: 90,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          color: jsonData.result!.totalCategoryScore >= 0.8
              ? ColorStyles.themeRed
              : ColorStyles.themeYellow),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "주의해야할 단어",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: (MediaQuery.of(context).size.width - 150),
                child: Text(
                  getKeywords().join("  "),
                  style: const TextStyle(
                    color: Colors.white,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: 70,
            child: RealtimeCircleProgressBar(
              textColor: Colors.white,
              score: jsonData.result!.totalCategoryScore as double,
            ),
          )
        ],
      ),
    );
  }
}
