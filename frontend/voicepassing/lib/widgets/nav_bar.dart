import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            icon: Icon(Icons.playlist_add_check),
            label: '검사 결과',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline),
            label: '통계',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '검색',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload_outlined),
            label: '파일 검사',
          )
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
              Get.to(() => const StaticsScreen(), transition: Transition.fade);
              break;
            case 3:
              Get.to(() => const SearchScreenResult(),
                  transition: Transition.fade);
              break;
            case 4:
              Get.to(() => const AnalyticsScreen(),
                  transition: Transition.fade);
              break;
          }
        },
      ),
    );
  }
}
