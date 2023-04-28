import 'package:flutter/material.dart';
import 'package:voicepassing/screens/search_screen.dart';
import 'package:voicepassing/widgets/img_button.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(1),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.settings,
                size: 24,
              ))
        ],
        leadingWidth: 120,
        leading: Builder(builder: (BuildContext context) {
          return SizedBox(
            width: 70,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Image.asset(
                'images/VoiceLogo.png',
                height: 30,
              ),
            ),
          );
        }),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Builder(
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    ImgButton(
                      title: '검사 결과',
                      ImgName: 'ResultImg',
                    ),
                    ImgButton(
                      title: '검사 결과',
                      ImgName: 'ResultImg',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    ImgButton(
                      title: '검사 결과',
                      ImgName: 'ResultImg',
                    ),
                    ImgButton(
                      title: '검사 결과',
                      ImgName: 'ResultImg',
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
