import 'package:flutter/material.dart';
import 'package:voicepassing/screens/main_screen.dart';
import 'package:voicepassing/style/color_style.dart';
import 'package:voicepassing/widgets/setting_widget/setting_button.dart';
import 'package:voicepassing/widgets/setting_widget/setting_head_bar.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SettingHeadBar(
        navPage: const MainScreen(),
        title: const Text('설정'),
        appBar: AppBar(),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 24),
            child: Column(
              children: [
                SettingBtn(
                  icon: const Icon(
                    Icons.check_box,
                    color: ColorStyles.themeLightBlue,
                  ),
                  content: "약관 및 개인정보 처리 동의",
                  routeName: "/permission",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
