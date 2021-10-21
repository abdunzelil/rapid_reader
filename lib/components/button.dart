import 'package:flutter/material.dart';

class ButtonView extends StatelessWidget {
  final Color butColor;
  final String text;
  final Function func;
  const ButtonView(
      {Key? key,
      required this.butColor,
      required this.func,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            primary: Colors.orangeAccent,
            side: BorderSide(color: butColor, width: 3)),
        onPressed: func(),
        child: Text(text,
            style: TextStyle(
                fontSize: 25, color: butColor, fontFamily: "BebasNeue")));
  }
}
