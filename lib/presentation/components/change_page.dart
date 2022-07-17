import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapid_reader_app/core/theme/custom_text_theme.dart';
import 'package:rapid_reader_app/core/theme/palette.dart';
import 'package:rapid_reader_app/data/enums/modify_page_num.dart';
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
          constraints: const BoxConstraints(),
          onPressed: () {
            state.modifyPagenum(ModifyPageNum.back);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Palette.label,
          )),
      Padding(
          padding: const EdgeInsets.only(right: 3),
          child: Text(val,
              style:
                  CustomTextTheme(context).bodyText1.copyWith(fontSize: 15))),
      IconButton(
          iconSize: 20,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () {
            state.modifyPagenum(ModifyPageNum.next);
          },
          icon: Icon(Icons.arrow_forward_ios, color: Palette.label)),
    ]);
  }
}
