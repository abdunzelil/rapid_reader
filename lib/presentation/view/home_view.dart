import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapid_reader_app/core/theme/palette.dart';
import 'package:rapid_reader_app/localization/app_localization.dart';
import 'package:rapid_reader_app/presentation/components/button.dart';
import 'package:rapid_reader_app/state/book_controller.dart';

import 'library_view.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final BookController state = Get.put(BookController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Palette.backgroundColor,
        body: SafeArea(child: buildHomeBody(context)),
      ),
    );
  }

  Widget buildHomeBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
            alignment: Alignment.topRight,
            child: IconButton(
                icon: Icon(Icons.info_outline,
                    color: Palette.primaryColor, size: 30),
                onPressed: () {
                  Get.defaultDialog(
                      backgroundColor: Palette.primaryColor,
                      barrierDismissible: true,
                      title: context.translate("GENERAL_INFO"),
                      titleStyle: context.textTheme.headline5!
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 25),
                      content: Text(
                        context.translate("DESC"),
                        style: context.textTheme.bodyText1!.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ));
                })),
        const Spacer(
          flex: 7,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Image.asset('assets/images/rapidreaderlogo.jpg'),
        ),
        const Spacer(
          flex: 1,
        ),
        Text(context.translate("READ_AN_ENTIRE_BOOK"),
            style: TextStyle(
              color: Palette.label,
              fontSize: 24,
              fontFamily: "Damion",
            )),
        const Spacer(
          flex: 10,
        ),
        CustomButton(
            text: context.translate("BLOCK_MODE"),
            fontSize: 40,
            func: () {
              state.setRoute("block");
              Get.to(() => LibraryPage());
            }),
        const Spacer(
          flex: 2,
        ),
        CustomButton(
            text: context.translate("SHADOW_MODE"),
            fontSize: 40,
            func: () {
              state.setRoute("shadow");
              Get.to(() => LibraryPage());
            }),
        const Spacer(
          flex: 2,
        ),
        CustomButton(
            text: context.translate("CHASING_MODE"),
            fontSize: 40,
            func: () {
              state.setRoute("chasing");
              Get.to(() => LibraryPage());
            }),
        const Spacer(
          flex: 10,
        ),
      ],
    );
  }
}
