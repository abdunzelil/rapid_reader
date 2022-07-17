import 'package:flutter/material.dart';
import 'package:rapid_reader_app/core/theme/palette.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback func;
  final int fontSize;
  const CustomButton(
      {Key? key, required this.func, required this.text, this.fontSize = 25})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            primary: Palette.primaryColor,
            side: BorderSide(color: Palette.primaryColor, width: 3)),
        onPressed: func,
        child: Text(text,
            style: TextStyle(
                fontSize: fontSize.toDouble(),
                color: Palette.primaryColor,
                fontFamily: "BebasNeue")));
  }
}
