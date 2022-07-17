import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapid_reader_app/core/extensions/size_extension.dart';
import 'package:rapid_reader_app/data/enums/set_font_size.dart';
import 'package:rapid_reader_app/state/book_controller.dart';

import '../../core/theme/palette.dart';

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
          constraints: const BoxConstraints(),
          onPressed: () {
            state.setFontSize(SetFontSize.down);
          },
          icon: Icon(
            Icons.remove_circle_outline,
            color: Palette.label,
          )),
      SizedBox(
        width: 10.sp,
      ),
      IconButton(
          iconSize: 20,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () {
            state.setFontSize(SetFontSize.up);
          },
          icon: Icon(Icons.add_circle_outline, color: Palette.label)),
    ]);
  }
}
