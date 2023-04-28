import 'package:flutter/material.dart';

class ImgButton extends StatelessWidget {
  final String title;
  final String ImgName;

  const ImgButton({super.key, required this.title, required this.ImgName});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(15)),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
        Image.asset(
          'images/$ImgName.png',
          height: 100,
        )
      ]),
    );
  }
}
