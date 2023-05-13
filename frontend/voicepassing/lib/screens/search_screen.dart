import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';
import 'package:voicepassing/screens/main_screen.dart';
import 'package:voicepassing/screens/search_screen_result.dart';
import 'package:voicepassing/style/color_style.dart';
import 'package:voicepassing/widgets/head_bar.dart';
import 'package:voicepassing/widgets/nav_bar.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HeadBar(
        navPage: MainScreen(),
        title: const Text('검색'),
        appBar: AppBar(),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  const TopTitle(),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SearchScreenResult()));
                        },
                        child: Hero(
                          tag: 'searchBar',
                          child: Container(
                            height: 34,
                            decoration: BoxDecoration(
                                color: ColorStyles.themeLightBlue,
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 7, horizontal: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(Icons.search, color: Colors.white),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    children: const [
                                      Text(
                                        '전화번호를 입력하세요',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text("보이스 피싱으로 의심하는 번호를 검색할 수 있습니다",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: ColorStyles.textDarkGray,
                          fontWeight: FontWeight.w400,
                          fontSize: 12))
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const Navbar(selectedIndex: 2),
    );
  }
}

class TopTitle extends StatelessWidget {
  const TopTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StyledText(
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: ColorStyles.textDarkGray),
                  text: '<b>전화번호</b>를',
                  tags: {
                    'b': StyledTextTag(
                        style: const TextStyle(
                            color: ColorStyles.themeLightBlue,
                            fontSize: 24,
                            fontWeight: FontWeight.w700))
                  },
                ),
                const Text('검색할 수 있습니다',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: ColorStyles.textDarkGray)),
              ],
            ),
          ),
          Flexible(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'images/SearchImg.png',
                fit: BoxFit.fill,
              ),
            ),
          )
        ],
      ),
    );
  }
}
