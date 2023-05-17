import 'package:flutter/material.dart';

class HeadBar extends StatelessWidget implements PreferredSizeWidget {
  final Text title;
  final AppBar appBar;
  final Widget? navPage;

  const HeadBar(
      {super.key, required this.title, required this.appBar, this.navPage});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'headBar',
      child: AppBar(
        leading: Builder(builder: (BuildContext context) {
          return Container();
        }),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/setting");
                // Navigator.of(context)
                //     .push(_customRoute(const RequestPermissionsScreen()));
              },
              icon: const Icon(
                Icons.settings,
                size: 24,
              ))
        ],
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white.withOpacity(1),
        foregroundColor: Colors.black,
        title: title,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
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
