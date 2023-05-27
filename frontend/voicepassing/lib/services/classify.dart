import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:voicepassing/style/color_style.dart';

class Classify {
  static Color getColor(double score, int catetory) {
    if (catetory == 0) {
      return ColorStyles.newBlue;
    }
    if (score >= 0.8) {
      return ColorStyles.themeRed;
    } else if (score >= 0.6) {
      return ColorStyles.newYellow;
    } else {
      return ColorStyles.newBlue;
    }
  }

  static Color getSentenceColor(double score, int catetory) {
    if (catetory == 0) {
      return ColorStyles.newBlue;
    }
    if (score >= 0.8) {
      return ColorStyles.themeRed;
    } else {
      return ColorStyles.newYellow;
    }
  }

  static Map<String, dynamic> getCategory(int num) {
    if (num == 1) {
      return {
        'type': "기관 사칭형",
        'color': ColorStyles.themeRed,
        'icon': MdiIcons.badgeAccount
      };
    } else if (num == 2) {
      return {
        "type": "대출 사기형",
        'color': ColorStyles.themeLightBlue,
        'icon': MdiIcons.cashMultiple
      };
    } else if (num == 3) {
      return {
        'type': "기타형",
        'color': ColorStyles.subDarkGray,
        'icon': MdiIcons.cashMultiple
      };
    } else {
      return {
        'type': "혐의 없음",
        'color': ColorStyles.subDarkGray,
        'icon': MdiIcons.thumbUpOutline
      };
    }
  }
}
