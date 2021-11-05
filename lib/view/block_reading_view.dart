import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:rapid_reader_app/components/button.dart';
import 'package:rapid_reader_app/components/change_page.dart';
import 'package:rapid_reader_app/components/font_edit.dart';
import 'package:rapid_reader_app/components/slider.dart';

import 'package:rapid_reader_app/state/book_controller.dart';

class BlockReading extends StatelessWidget {
  final state = Get.find<BookController>();

  BlockReading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: const Color(0xFF121212),
            body: Obx(() {
              return state.isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 20),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    const Text(" Words Per Minute",
                                        style: TextStyle(
                                            color: Colors.orangeAccent,
                                            fontFamily: "BebasNeue",
                                            fontSize: 20)),
                                    CustomSlider(
                                        form: "speed",
                                        thumb: Colors.purpleAccent,
                                        active: Colors.purpleAccent
                                            .withOpacity(0.7),
                                        inactive: Colors.purpleAccent
                                            .withOpacity(0.5)),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Text("Num of Words display",
                                        style: TextStyle(
                                            color: Colors.orangeAccent,
                                            fontFamily: "BebasNeue",
                                            fontSize: 20)),
                                    RotatedBox(
                                        quarterTurns: 1,
                                        child: CustomSlider(
                                            active: Colors.purpleAccent
                                                .withOpacity(0.7),
                                            form: "word",
                                            inactive: Colors.purpleAccent
                                                .withOpacity(0.5),
                                            thumb: Colors.purpleAccent)),
                                  ],
                                ),
                              ],
                            ),
                            Center(
                              child: Container(
                                child: Text(state.blockStr.value,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            state.fontSize.value.toDouble(),
                                        fontFamily: "LibreBaskerville")),
                              ),
                            ),
                            buildButton(),
                          ]),
                    );
            })));
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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonView(
                        fontSize: 25,
                        butColor: Colors.orangeAccent,
                        func: (isRunning) ? state.stopTimer : state.startTimer,
                        text: isRunning ? 'Pause' : 'Resume'),
                    SizedBox(
                      width: 15,
                    ),
                    ButtonView(
                        fontSize: 25,
                        butColor: Colors.orangeAccent,
                        func: state.prevWord,
                        text: "Previous"),
                  ],
                ),
                !isRunning
                    ? Column(
                        children: [
                          ButtonView(
                              fontSize: 25,
                              butColor: Colors.orangeAccent,
                              func: () {
                                state.updateBook(
                                    indexInPage: state.index,
                                    pageNo: state.pageNo,
                                    totalPage: state.totalPage.value);
                              },
                              text: "Save Progress"),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ModifyPage(
                                  val:
                                      "${state.pageNo} / ${state.totalPage.value}"),
                              SizedBox(
                                width: 60,
                              ),
                              FontChanger(val: state.fontSize.value.toString())
                            ],
                          )
                        ],
                      )
                    : SizedBox(
                        height: 20,
                      ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: LinearProgressIndicator(
                    minHeight: 5,
                    color: Colors.orangeAccent,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    value: (state.pageNo / state.totalPage.value),
                  ),
                )
              ],
            )
          : Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ButtonView(
                  fontSize: 25,
                  butColor: Colors.orangeAccent,
                  func: state.startTimer,
                  text: "START"));
    }
  }
}
