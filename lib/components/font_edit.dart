import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapid_reader_app/state/book_controller.dart';

class FontChanger extends StatelessWidget {
  final String val;
  final state = Get.find<BookController>();
  FontChanger({Key? key, required this.val}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      IconButton(
          iconSize: 20,
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          onPressed: () {
            state.setFontSize("down");
          },
          icon: Icon(
            Icons.remove_circle_outline,
            color: Colors.white,
          )),
      SizedBox(
        width: 10,
      ),
      IconButton(
          iconSize: 20,
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          onPressed: () {
            state.setFontSize("up");
          },
          icon: Icon(Icons.add_circle_outline, color: Colors.white)),
    ]);
  }
}
