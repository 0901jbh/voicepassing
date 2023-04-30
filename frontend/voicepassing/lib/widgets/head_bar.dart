import 'package:flutter/material.dart';

class HeadBar extends StatelessWidget implements PreferredSizeWidget {
  final Text title;
  final AppBar appBar;
  final Widget? navPage;

  const HeadBar(
      {super.key, required this.title, required this.appBar, this.navPage});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Builder(builder: (BuildContext context) {
        return IconButton(
          icon: const Icon(Icons.arrow_back_ios),
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
        );
      }),
      actions: [
        IconButton(
            onPressed: () {},
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
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
