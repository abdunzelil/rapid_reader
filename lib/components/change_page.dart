import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapid_reader_app/state/book_controller.dart';

class ModifyPage extends StatelessWidget {
  final state = Get.find<BookController>();
  final String val;
  ModifyPage({Key? key, required this.val}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      IconButton(
          iconSize: 20,
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          onPressed: () {
            state.modifyPagenum("back");
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          )),
      Padding(
        padding: const EdgeInsets.only(right: 3),
        child: Text(val,
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontFamily: "BebasNeue")),
      ),
      IconButton(
          iconSize: 20,
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          onPressed: () {
            state.modifyPagenum("next");
          },
          icon: Icon(Icons.arrow_forward_ios, color: Colors.white)),
    ]);
  }
}
