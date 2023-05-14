import 'package:flutter/material.dart';

class SettingBtn extends StatelessWidget {
  SettingBtn({
    super.key,
    required this.icon,
    required this.content,
    required this.routeName,
  });

  Icon icon;
  String content;
  String routeName;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(routeName);
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    icon,
                    const SizedBox(width: 12),
                    Text(content),
                  ],
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
              ],
            ),
          ),
        ));
  }
}
