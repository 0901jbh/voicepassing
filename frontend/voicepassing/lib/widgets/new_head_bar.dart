import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:voicepassing/screens/main_screen.dart';
import 'package:voicepassing/style/color_style.dart';

class NewHeadBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final Widget? navPage;

  const NewHeadBar({super.key, required this.name, this.navPage});

  @override
  Widget build(BuildContext context) {
    String title;
    String subtitle;
    IconData backgroundIcon;
    switch (name) {
      case 'result':
        title = '검사 내역';
        subtitle = '보이스피싱 검사 내역을 확인해보세요';
        backgroundIcon = MdiIcons.newspaperVariantOutline;
        break;
      case 'statistics':
        title = '통계';
        subtitle = '범죄 유형별 통계와 문장을 확인하세요';
        backgroundIcon = MdiIcons.finance;
        break;
      case 'analytics':
        title = '녹음 파일 검사';
        subtitle = '음성 파일을 검사할 수 있습니다';
        backgroundIcon = MdiIcons.folderUploadOutline;
        break;
      default:
        title = 'TITLE';
        subtitle = 'subtitle';
        backgroundIcon = MdiIcons.abTesting;
        break;
    }
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
                    : Get.to(() => const MainScreen(),
                        transition: Transition.fade);
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => navPage!,
                //     ),
                //   );
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
                    child: Icon(
                      backgroundIcon,
                      color: ColorStyles.newLightBlue,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
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
