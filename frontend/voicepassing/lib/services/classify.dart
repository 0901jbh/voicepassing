import 'package:voicepassing/style/color_style.dart';

class Classify {
  static Map<String, dynamic> getCategory(int num) {
    if (num == 1) {
      return {'type': "기관 사칭형", 'color': ColorStyles.themeRed};
    } else if (num == 2) {
      return {"type": "대출 사기형", 'color': ColorStyles.themeLightBlue};
    } else {
      return {'type': "기타형", 'color': ColorStyles.subDarkGray};
    }
  }
}
