import 'package:flutter/material.dart';
import 'package:voicepassing/screens/analytics_screen.dart';
import 'package:voicepassing/screens/main_screen.dart';
import 'package:voicepassing/screens/result_screen.dart';
import 'package:voicepassing/screens/search_screen.dart';
import 'package:voicepassing/screens/statics_screen.dart';

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
            icon: Icon(Icons.pie_chart_outline),
            label: '통계',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '검색',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_add_check),
            label: '검사 결과',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload_outlined),
            label: '파일 검사',
          )
        ],
        currentIndex: widget.selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: const Color(0xffB1B8C0),
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScreen(),
                ),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StaticsScreen(),
                ),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ResultScreen(),
                ),
              );
              break;
            case 4:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AnalyticsScreen(),
                ),
              );
              break;
          }
        },
      ),
    );
  }
}
