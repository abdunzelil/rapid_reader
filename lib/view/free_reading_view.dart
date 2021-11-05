import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:rapid_reader_app/components/button.dart';
import 'package:rapid_reader_app/components/change_page.dart';
import 'package:rapid_reader_app/components/slider.dart';

import 'package:rapid_reader_app/state/book_controller.dart';

class FreeReading extends StatelessWidget {
  final state = Get.find<BookController>();

  FreeReading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor =
        (state.route.value == "chasing") ? Colors.white : Colors.black;

    final containerColor = (state.route.value == "chasing")
        ? Color(0xff032a3b).withOpacity(0.8)
        : Colors.black.withOpacity(0.8);
    return SafeArea(child: Obx(() {
      return Scaffold(
          backgroundColor:
              (state.route == "shadow") ? Color(0xFFe5cda7) : Color(0xFF121212),
          body: state.isLoading.value
              ? Center(child: CircularProgressIndicator())
              : Stack(children: [
                  GestureDetector(
                    onTap: () => state.changeIsVisible(),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 10, bottom: 10),
                          child: RichText(
                            text: TextSpan(children: [
                              textSpanner(textColor.withOpacity(0.1),
                                  state.firstFree.value),
                              (state.route.value == "shadow")
                                  ? (state.wordDeger == 2)
                                      ? TextSpan(children: [
                                          widgetSpanner(
                                              state.secFree.value + " ",
                                              BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10))),
                                          widgetSpanner(
                                              state.thirdFree.value,
                                              BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10))),
                                        ])
                                      : widgetSpanner(state.secFree.value,
                                          BorderRadius.circular(10))
                                  : (state.wordDeger == 2)
                                      ? textSpanner(
                                          Colors.white,
                                          state.secFree.value +
                                              " " +
                                              state.thirdFree.value,
                                        )
                                      : textSpanner(
                                          Colors.white, state.secFree.value),
                              textSpanner(textColor.withOpacity(0.1),
                                  state.fourthFree.value)
                            ]),
                          )),
                    ),
                  ),
                  Align(
                      alignment: Alignment(0, 0.9),
                      child: buildSettingContainer(containerColor)),
                ]));
    }));
  }

  Widget buildSettingContainer(Color containerColor) {
    return Visibility(
        visible: state.isContVisible.value,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: containerColor,
          ),
          width: 350,
          height: 250,
          child: Center(child: buildButton()),
        ));
  }

  Widget buildButton() {
    final isRunning = state.isTimerRunning.value;
    final isStarting = (state.pageNo == 1 && state.index == 0);
    if (state.pageNo == state.totalPage.value &&
        ((state.indexWordSlider.value == 0 &&
                state.index == state.listOfWord.length - 1) ||
            (state.indexWordSlider.value == 1 &&
                state.index == state.listOfWord.length - 2))) {
      return ButtonView(
          fontSize: 25,
          butColor: Colors.orangeAccent,
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
                    ButtonView(
                        butColor: Colors.orangeAccent,
                        func: (isRunning) ? state.stopTimer : state.startTimer,
                        text: isRunning ? 'Pause' : 'Resume',
                        fontSize: 15),
                    SizedBox(
                      width: 15,
                    ),
                    ButtonView(
                        butColor: Colors.orangeAccent,
                        func: state.prevWord,
                        text: "Previous",
                        fontSize: 15),
                  ],
                ),
                !isRunning
                    ? Column(
                        children: [
                          ButtonView(
                              butColor: Colors.orangeAccent,
                              func: () {
                                state.updateBook(
                                    indexInPage: state.index,
                                    pageNo: state.pageNo,
                                    totalPage: state.totalPage.value);
                              },
                              text: "Save Progress",
                              fontSize: 15),
                          SizedBox(
                            height: 5,
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
                        height: 5,
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: LinearProgressIndicator(
                    minHeight: 5,
                    color: Colors.orangeAccent,
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
                            thumb: Colors.purpleAccent,
                            active: Colors.purpleAccent.withOpacity(0.7),
                            inactive: Colors.purpleAccent.withOpacity(0.5)),
                        Text(
                          "Words per Min",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.orangeAccent,
                              fontFamily: "BebasNeue"),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        CustomSlider(
                            form: "word",
                            thumb: Colors.purpleAccent,
                            active: Colors.purpleAccent.withOpacity(0.7),
                            inactive: Colors.purpleAccent.withOpacity(0.5)),
                        Text("Num of Words display",
                            style: TextStyle(
                                color: Colors.orangeAccent,
                                fontFamily: "BebasNeue",
                                fontSize: 15)),
                      ],
                    )
                  ],
                )
              ],
            )
          : Container(
              padding: EdgeInsets.all(70),
              child: ButtonView(
                butColor: Colors.orangeAccent,
                fontSize: 25,
                func: state.startTimer,
                text: "START",
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
          style: TextStyle(
              fontSize: 19,
              color: Colors.white,
              fontWeight: FontWeight.normal,
              fontFamily: "LibreBaskerville"),
        ),
      ),
    );
  }
}
