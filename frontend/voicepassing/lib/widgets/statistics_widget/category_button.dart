import 'package:flutter/material.dart';
import 'package:voicepassing/style/color_style.dart';

class CategoryButton extends StatefulWidget {
  final int productNum;
  final int selectedNum;
  final String category;
  final Function changeNum;

  const CategoryButton(
      this.productNum, this.selectedNum, this.category, this.changeNum,
      {super.key});

  @override
  State<CategoryButton> createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        widget.changeNum(widget.productNum);
      },
      style: ButtonStyle(
          backgroundColor: widget.productNum == widget.selectedNum
              ? MaterialStateProperty.all(ColorStyles.themeLightBlue)
              : MaterialStateProperty.all(ColorStyles.backgroundBlue),
          overlayColor: MaterialStateProperty.all(ColorStyles.themeSkyBlue),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          fixedSize: MaterialStateProperty.all(Size.fromWidth(
            MediaQuery.of(context).size.width / 3 - 20,
          ))),
      child: Text(
        widget.category,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: widget.productNum == widget.selectedNum
                ? Colors.white
                : ColorStyles.themeLightBlue),
      ),
    );
  }
}
