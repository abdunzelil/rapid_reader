import 'package:flutter/material.dart';

class ButtonView extends StatelessWidget {
  final Color butColor;
  final String text;
  final VoidCallback func;
  final int fontSize;
  const ButtonView(
      {Key? key,
      required this.butColor,
      required this.func,
      required this.text,
      required this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            primary: butColor, side: BorderSide(color: butColor, width: 3)),
        onPressed: func,
        child: Text(text,
            style: TextStyle(
                fontSize: fontSize.toDouble(),
                color: butColor,
                fontFamily: "BebasNeue")));
  }
}
