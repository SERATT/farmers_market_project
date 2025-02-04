import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final TextStyle textStyle;
  final double padding;
  final double margin;
  final double borderRadius;
  final Color fillInColor;

  const MyButton({super.key, required this.onTap, required this.text, required this.textStyle, required this.padding, required this.margin, required this.borderRadius, required this.fillInColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(padding),
        margin: EdgeInsets.symmetric(horizontal: margin),
        decoration: BoxDecoration(
          color: fillInColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child:  Center(
          child: Text(
            text,
            style: textStyle
          ),
        ),
      ),
    );
  }
}