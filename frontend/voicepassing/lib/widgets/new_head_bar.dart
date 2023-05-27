import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:voicepassing/style/color_style.dart';

class NewHeadBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final Widget? navPage;

  const NewHeadBar(
      {super.key, required this.title, this.subtitle, this.navPage});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'headBar',
      child: PreferredSize(
        preferredSize: preferredSize,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(12),
            ),
            color: ColorStyles.newBlue,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                spreadRadius: 3,
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: AppBar(
            toolbarHeight: 90,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                color: Colors.white,
                onPressed: () {
                  navPage == null
                      ? Navigator.pop(context)
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => navPage!,
                          ),
                        );
                },
              ),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            title: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: MediaQuery.of(context).size.width - 140,
                  top: 25,
                  child: Transform.scale(
                    scale: 5,
                    child: const Icon(
                      MdiIcons.newspaperVariantOutline, 
                      color: ColorStyles.newLightBlue,
                    ),
                  ),
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '검사 내역', 
                      style: TextStyle(
                        fontSize: 30, 
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '보이스피싱 검사 내역을 확인하세요', 
                      style: TextStyle(
                        fontSize: 15, 
                        fontWeight: FontWeight.w400,
                        color: ColorStyles.subGray,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(90);
}

Route _customRoute(Widget route) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => route,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
