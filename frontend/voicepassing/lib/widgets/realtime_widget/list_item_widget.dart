import 'package:flutter/material.dart';
import 'package:voicepassing/models/receive_message_model.dart';
import 'package:voicepassing/style/color_style.dart';

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
      padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
      width: MediaQuery.of(context).size.width,
      height: 63,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: jsonData.result!.totalCategoryScore >= 0.8
              ? ColorStyles.themeRed
              : ColorStyles.themeYellow,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 0,
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "의심 단어",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
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
          Text(
            (jsonData.result!.totalCategoryScore * 100).round().toString(), 
            style: const TextStyle(
              color: Colors.white, 
              fontSize: 36, 
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
