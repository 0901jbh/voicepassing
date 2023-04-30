import 'package:flutter/material.dart';

class ImgButton extends StatelessWidget {
  final String title;
  final String imgName;
  final Widget screenWidget;

  const ImgButton(
      {super.key,
      required this.title,
      required this.imgName,
      required this.screenWidget});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => screenWidget,
          ),
        );
      },
      child: Container(
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
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18),
            ),
          ),
          Image.asset(
            'images/$imgName.png',
            height: 80,
          )
        ]),
      ),
    );
  }
}
