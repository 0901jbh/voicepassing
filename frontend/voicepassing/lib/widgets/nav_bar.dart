import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:voicepassing/screens/analytics_screen.dart';
import 'package:voicepassing/screens/main_screen.dart';
import 'package:voicepassing/screens/result_screen.dart';
import 'package:voicepassing/screens/search_screen_result.dart';
import 'package:voicepassing/screens/statics_screen.dart';
import 'package:voicepassing/style/color_style.dart';

class Navbar extends StatefulWidget {
  final int selectedIndex;

  const Navbar({super.key, required this.selectedIndex});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'Navbar',
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '메인',
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.newspaperVariantMultiple),
            label: '검사 내역',
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.folderUploadOutline),
            label: '파일 검사',
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.finance),
            label: '통계',
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.clipboardTextSearch),
            label: '검색',
          ),
        ],
        currentIndex: widget.selectedIndex,
        selectedItemColor: ColorStyles.newBlue,
        unselectedItemColor: const Color(0xffB1B8C0),
        onTap: (int index) {
          switch (index) {
            case 0:
              Get.to(() => const MainScreen(), transition: Transition.fade);
              break;
            case 1:
              Get.to(() => const ResultScreen(), transition: Transition.fade);
              break;
            case 2:
              Get.to(() => const AnalyticsScreen(),
                  transition: Transition.fade);
              break;

            case 3:
              Get.to(() => const StaticsScreen(), transition: Transition.fade);
              break;

            case 4:
              Get.to(() => const SearchScreenResult(),
                  transition: Transition.fade);
              break;
          }
        },
      ),
    );
  }
}
