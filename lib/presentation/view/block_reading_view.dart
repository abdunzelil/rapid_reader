import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapid_reader_app/core/extensions/size_extension.dart';
import 'package:rapid_reader_app/localization/app_localization.dart';

import 'package:rapid_reader_app/presentation/components/components.dart';

import 'package:rapid_reader_app/state/book_controller.dart';

import '../../core/theme/palette.dart';

class BlockReading extends StatelessWidget {
  final state = Get.find<BookController>();

  BlockReading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Palette.backgroundColor,
            body: Obx(() {
              return state.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 20),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            sliderWidget(context),
                            Center(
                              child: Text(state.blockStr.value,
                                  style: TextStyle(
                                      color: Palette.label,
                                      fontSize: state.fontSize.value.toDouble(),
                                      fontFamily: "LibreBaskerville")),
                            ),
                            buildButton(context),
                          ]),
                    );
            })));
  }

  Row sliderWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(context.translate("WORDS_PER_MINUTE"),
                style: TextStyle(
                    color: Palette.primaryColor,
                    fontFamily: "BebasNeue",
                    fontSize: 18)),
            CustomSlider(
                form: "speed",
                thumb: Palette.secondaryColor,
                active: Palette.secondaryColor.withOpacity(0.7),
                inactive: Palette.secondaryColor.withOpacity(0.5)),
          ],
        ),
        Column(
          children: [
            Text(context.translate("NUM_OF_WORDS"),
                style: TextStyle(
                    color: Palette.primaryColor,
                    fontFamily: "BebasNeue",
                    fontSize: 18)),
            RotatedBox(
                quarterTurns: 1,
                child: CustomSlider(
                    active: Palette.secondaryColor.withOpacity(0.7),
                    form: "word",
                    inactive: Palette.secondaryColor.withOpacity(0.5),
                    thumb: Palette.secondaryColor)),
          ],
        ),
      ],
    );
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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                        func: (isRunning) ? state.stopTimer : state.startTimer,
                        text: isRunning
                            ? context.translate("PAUSE")
                            : context.translate("RESUME")),
                    SizedBox(
                      width: 15.sp,
                    ),
                    CustomButton(
                        func: state.prevWord,
                        text: context.translate("PREVIOUS")),
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
                              text: context.translate("SAVE_PROGRESS")),
                          SizedBox(
                            height: 10.sp,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ModifyPage(
                                  val:
                                      "${state.pageNo} / ${state.totalPage.value}"),
                              SizedBox(
                                width: 60.sp,
                              ),
                              FontChanger(val: state.fontSize.value.toString())
                            ],
                          )
                        ],
                      )
                    : SizedBox(
                        height: 20.sp,
                      ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: LinearProgressIndicator(
                    minHeight: 5.sp,
                    color: Palette.primaryColor,
                    backgroundColor: Palette.label.withOpacity(0.2),
                    value: (state.pageNo / state.totalPage.value),
                  ),
                )
              ],
            )
          : Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: CustomButton(
                  func: state.startTimer, text: context.translate("START")));
    }
  }
}
