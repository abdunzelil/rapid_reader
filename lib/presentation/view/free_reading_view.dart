import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapid_reader_app/core/extensions/size_extension.dart';
import 'package:rapid_reader_app/core/theme/palette.dart';
import 'package:rapid_reader_app/localization/app_localization.dart';

import 'package:rapid_reader_app/presentation/components/components.dart';

import 'package:rapid_reader_app/state/book_controller.dart';

class FreeReading extends StatelessWidget {
  final state = Get.find<BookController>();

  FreeReading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor =
        (state.route.value == "chasing") ? Colors.white : Colors.black;

    final containerColor = (state.route.value == "chasing")
        ? const Color(0xff032a3b).withOpacity(0.8)
        : Colors.black.withOpacity(0.8);
    return SafeArea(child: Obx(() {
      return Scaffold(
          backgroundColor: (state.route.value == "shadow")
              ? const Color(0xFFe5cda7)
              : Palette.backgroundColor,
          body: state.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : Stack(children: [
                  GestureDetector(
                    onTap: () => state.changeIsVisible(),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          child: RichText(
                            text: TextSpan(children: [
                              textSpanner(textColor.withOpacity(0.1),
                                  state.firstFree.value),
                              (state.route.value == "shadow")
                                  ? (state.wordDeger.value == 2)
                                      ? TextSpan(children: [
                                          widgetSpanner(
                                              state.secFree.value + " ",
                                              const BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10))),
                                          widgetSpanner(
                                              state.thirdFree.value,
                                              const BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10))),
                                        ])
                                      : widgetSpanner(state.secFree.value,
                                          BorderRadius.circular(10))
                                  : (state.wordDeger.value == 2)
                                      ? textSpanner(
                                          Palette.label,
                                          state.secFree.value +
                                              " " +
                                              state.thirdFree.value,
                                        )
                                      : textSpanner(
                                          Palette.label, state.secFree.value),
                              textSpanner(textColor.withOpacity(0.1),
                                  state.fourthFree.value)
                            ]),
                          )),
                    ),
                  ),
                  Align(
                      alignment: const Alignment(0, 0.9),
                      child: buildSettingContainer(containerColor, context)),
                ]));
    }));
  }

  Widget buildSettingContainer(Color containerColor, BuildContext context) {
    return Visibility(
        visible: state.isContVisible.value,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: containerColor,
          ),
          width: 350.sp,
          height: 250.sp,
          child: Center(child: buildButton(context)),
        ));
  }

  Widget buildButton(BuildContext context) {
    final isRunning = state.isTimerRunning.value;
    final isStarting = (state.pageNo == 1 && state.index == 0);
    if (state.pageNo == state.totalPage.value &&
        ((state.indexWordSlider.value == 0 &&
                state.index == state.listOfWord.length - 1) ||
            (state.indexWordSlider.value == 1 &&
                state.index == state.listOfWord.length - 2))) {
      return CustomButton(
          func: () {
            state.updateBook(
                indexInPage: state.index,
                pageNo: state.pageNo,
                totalPage: state.totalPage.value);
            Get.back();
          },
          text: "BACK");
    } else {
      return isRunning || !isStarting
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                        func: (isRunning) ? state.stopTimer : state.startTimer,
                        text: isRunning
                            ? context.translate("PAUSE")
                            : context.translate("RESUME"),
                        fontSize: 15),
                    SizedBox(
                      width: 15.sp,
                    ),
                    CustomButton(
                        func: state.prevWord,
                        text: context.translate("PREVIOUS"),
                        fontSize: 15),
                  ],
                ),
                !isRunning
                    ? Column(
                        children: [
                          CustomButton(
                              func: () {
                                state.updateBook(
                                    indexInPage: state.index,
                                    pageNo: state.pageNo,
                                    totalPage: state.totalPage.value);
                              },
                              text: context.translate("SAVE_PROGRESS"),
                              fontSize: 15),
                          SizedBox(
                            height: 5.sp,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ModifyPage(
                                    val:
                                        "${state.pageNo} / ${state.totalPage.value}"),
                              ]),
                        ],
                      )
                    : SizedBox(
                        height: 5.sp,
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: LinearProgressIndicator(
                    minHeight: 5.sp,
                    color: Palette.primaryColor,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    value: (state.pageNo / state.totalPage.value),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        CustomSlider(
                            form: "speed",
                            thumb: Palette.secondaryColor,
                            active: Palette.secondaryColor.withOpacity(0.7),
                            inactive: Palette.secondaryColor.withOpacity(0.5)),
                        Text(
                          context.translate("WORDS_PER_MINUTE"),
                          style: TextStyle(
                              fontSize: 15,
                              color: Palette.primaryColor,
                              fontFamily: "BebasNeue"),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        CustomSlider(
                            form: "word",
                            thumb: Palette.secondaryColor,
                            active: Palette.secondaryColor.withOpacity(0.7),
                            inactive: Palette.secondaryColor.withOpacity(0.5)),
                        Text(context.translate("NUM_OF_WORDS"),
                            style: TextStyle(
                                color: Palette.primaryColor,
                                fontFamily: "BebasNeue",
                                fontSize: 15)),
                      ],
                    )
                  ],
                )
              ],
            )
          : Container(
              padding: const EdgeInsets.all(70),
              child: CustomButton(
                func: state.startTimer,
                text: context.translate("START"),
              ),
            );
    }
  }

  textSpanner(Color color, String text) {
    return TextSpan(
        text: text,
        style: TextStyle(
            color: color,
            fontSize: 19.0,
            fontWeight: FontWeight.bold,
            fontFamily: "LibreBaskerville"));
  }

  widgetSpanner(String text, BorderRadius borderRadius) {
    return WidgetSpan(
      child: Container(
        decoration:
            BoxDecoration(color: Colors.black, borderRadius: borderRadius),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 19,
              color: Colors.white,
              fontWeight: FontWeight.normal,
              fontFamily: "LibreBaskerville"),
        ),
      ),
    );
  }
}
