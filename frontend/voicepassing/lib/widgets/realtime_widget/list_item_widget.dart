import 'package:flutter/material.dart';
import 'package:voicepassing/style/color_style.dart';

class ListItemWidget extends StatelessWidget {
  const ListItemWidget({super.key, required jsonData});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80,
        width: double.infinity,
        color: ColorStyles.themeRed,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "위험",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            Text("키워드",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ))
          ],
        ));
  }
}
