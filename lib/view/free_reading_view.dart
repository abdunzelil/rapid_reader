import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:rapid_reader_app/api/pdf_api.dart';
import 'package:rapid_reader_app/db/books_database.dart';
import 'package:rapid_reader_app/model/book.dart';
import 'package:rapid_reader_app/view/home_view.dart';

class FreeReading extends StatefulWidget {
  final int indexInPage;
  final int idBook;
  final int pageNo;

  const FreeReading(
      {Key? key,
      required this.idBook,
      required this.indexInPage,
      required this.pageNo})
      : super(key: key);

  @override
  _FreeReadingState createState() =>
      _FreeReadingState(this.idBook, this.indexInPage, this.pageNo);
}

class _FreeReadingState extends State<FreeReading> {
  bool isVisible = true;
  late Book book;
  bool isLoading = false;
  int idBook;
  late List<String> listOfWord;
  int index = 0;
  Timer? timer;
  late int wordDeger;
  late int speedDeger;
  int totalPage = 200;

  int pageNo = 0;
  int indexWordSlider = 0;
  int indexSpeedSlider = 0;

  String path = "";

  _FreeReadingState(this.idBook, this.index, this.pageNo);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshBook();
  }

  Future refreshBook() async {
    setState(() => isLoading = true);

    book = await BooksDatabase.instance.getBook(idBook);
    listOfWord = await PDFApi.pdfToStr(File(book.path), book.pageNo);
    if (pageNo == 1) {
      totalPage = int.parse(listOfWord[listOfWord.length - 1]);
      listOfWord.removeAt(listOfWord.length - 1);
      await BooksDatabase.instance.update(book.copy(totalPage: totalPage));
      book = await BooksDatabase.instance.getBook(idBook);
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Stack(children: [
                GestureDetector(
                  onTap: () => setState(() => isVisible = !isVisible),
                  child: Scrollbar(
                    radius: Radius.circular(50),
                    isAlwaysShown: true,
                    showTrackOnHover: true,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 10, bottom: 10),
                          child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: listOfWord.sublist(0, index).join(" "),
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.1),
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: (indexWordSlider == 0)
                                      ? " " + listOfWord[index] + " "
                                      : " " +
                                          listOfWord[index] +
                                          " " +
                                          listOfWord[index + 1] +
                                          " ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: (indexWordSlider == 0)
                                      ? listOfWord.sublist(index + 1).join(' ')
                                      : listOfWord.sublist(index + 2).join(' '),
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.1),
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold))
                            ]),
                          )),
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment(0, 0.9),
                    child: buildSettingContainer()),
              ]),
            ),
    );
  }

  Widget buildSettingContainer() {
    return Visibility(
        visible: isVisible,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black.withOpacity(0.7)),
          width: 350,
          height: 250,
          child: Center(child: buildButton()),
        ));
  }

  void startTimer() {
    timer = Timer.periodic(
        Duration(milliseconds: miliSecondCalculator(wordDeger, speedDeger)),
        (_) {
      setState(() {
        if (indexWordSlider == 0) {
          if (index <= (listOfWord.length - 2)) {
            index++;
          } else {
            if (pageNo < book.totalPage) {
              pageNo++;

              changeList();
              index = 0;
            } else {
              stopTimer(prev: false);
            }
          }
        } else {
          if (index <= (listOfWord.length - 4)) {
            index = index + 2;
          } else if (index <= (listOfWord.length - 3)) {
            listOfWord.add(" ");
            index = index + 2;
          } else {
            if (pageNo < book.totalPage) {
              pageNo++;
              changeList();
              index = 0;
            } else {
              stopTimer(prev: false);
            }
          }
        }
      });
    });
  }

  void changeList() async {
    setState(() => isLoading = true);
    listOfWord = await PDFApi.pdfToStr(File(book.path), pageNo);
    setState(() => isLoading = false);
  }

  void prevWord() {
    if (index > 0) {
      setState(() {
        index--;
      });
    }
  }

  void stopTimer({bool prev = true}) {
    if (prev) {
      prevWord();
      return;
    }
    setState(() => timer?.cancel());
  }

  Widget buildButton() {
    final isRunning = timer == null ? false : timer!.isActive;
    final isStarting = (pageNo == 1 && index == 0);
    if (pageNo == book.totalPage &&
        ((indexWordSlider == 0 && index == listOfWord.length - 1) ||
            (indexWordSlider == 1 && index == listOfWord.length - 2))) {
      return OutlinedButton(
          style: OutlinedButton.styleFrom(
              primary: Colors.orangeAccent,
              side: BorderSide(color: Colors.orangeAccent, width: 3)),
          onPressed: () async {
            await BooksDatabase.instance
                .update(book.copy(indexInPage: index, pageNo: pageNo));
            Navigator.pop(context);
          },
          child: Text(
            "BACK",
            style: TextStyle(
                color: Colors.orangeAccent,
                fontSize: 25,
                fontFamily: "BebasNeue"),
          ));
    } else {
      return isRunning || !isStarting
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            primary: Colors.orangeAccent,
                            side: BorderSide(
                                color: Colors.orangeAccent, width: 3)),
                        onPressed: () {
                          if (isRunning) {
                            stopTimer(prev: false);
                          } else {
                            startTimer();
                          }
                        },
                        child: Text(
                          isRunning ? 'Pause' : 'Resume',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.orangeAccent,
                              fontFamily: "BebasNeue"),
                        )),
                    SizedBox(
                      width: 15,
                    ),
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            primary: Colors.orange,
                            side: BorderSide(
                                color: Colors.orangeAccent, width: 3)),
                        onPressed: () {
                          stopTimer();
                        },
                        child: Text("Previous Word",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.orangeAccent,
                                fontFamily: "BebasNeue")))
                  ],
                ),
                !isRunning
                    ? Column(
                        children: [
                          OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  primary: Colors.orangeAccent,
                                  side: BorderSide(
                                      color: Colors.orangeAccent, width: 3)),
                              onPressed: () async {
                                await BooksDatabase.instance.update(book.copy(
                                  indexInPage: index,
                                  pageNo: pageNo,
                                ));
                              },
                              child: Text("Save Progress",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.orangeAccent,
                                      fontFamily: "BebasNeue"))),
                          SizedBox(
                            height: 5,
                          ),
                          Text("$pageNo / ${book.totalPage}",
                              style: TextStyle(
                                  color: Colors.white, fontFamily: "BebasNeue"))
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
                    value: (book.pageNo / book.totalPage),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        buildSpeedSlider(),
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
                        buildWordSlider(),
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
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    primary: Colors.orangeAccent,
                    side:
                        const BorderSide(color: Colors.orangeAccent, width: 3)),
                child: const Text(
                  "START",
                  style: TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: 25,
                      fontFamily: "BebasNeue"),
                ),
                onPressed: () {
                  startTimer();
                },
              ),
            );
    }
  }

  int miliSecondCalculator(int wordDeger, int speedDeger) {
    int miliSecon = 200;
    if (wordDeger == 1) {
      miliSecon = (60000 / speedDeger).round();
    } else if (wordDeger == 2) {
      miliSecon = (60000 / speedDeger * 2).round();
    }
    return miliSecon;
  }

  Widget buildSpeedSlider() {
    final labels = [
      '120',
      '150',
      '180',
      '210',
      '240',
      '270',
      '300',
      '330',
      '360',
      '390',
      '420',
      '450',
      '480',
      '510',
      '540',
      '570',
      '600'
    ];
    final double min = 0;
    final isRunning = timer == null ? false : timer!.isActive;
    final double max = labels.length - 1.0;
    final divisions = labels.length - 1;
    speedDeger = indexSpeedSlider * 30 + 120;
    return Slider(
        value: indexSpeedSlider.toDouble(),
        thumbColor: Colors.orangeAccent,
        activeColor: Colors.blueAccent.withOpacity(0.6),
        inactiveColor: Colors.purpleAccent.withOpacity(0.7),
        max: max,
        min: min,
        divisions: divisions,
        label: '$speedDeger',
        onChanged: (value) {
          if (!isRunning) {
            setState(() => this.indexSpeedSlider = value.toInt());
          } else {
            null;
          }
        });
  }

  Widget buildWordSlider() {
    final labels = ['1', '2'];
    final double min = 0;
    wordDeger = indexWordSlider + 1;
    final double max = labels.length - 1.0;
    final divisions = labels.length - 1;
    return Container(
      width: 80,
      child: Slider(
          thumbColor: Colors.orangeAccent,
          inactiveColor: Colors.purpleAccent.withOpacity(0.7),
          activeColor: Colors.blueAccent.withOpacity(0.6),
          value: indexWordSlider.toDouble(),
          max: max,
          min: min,
          divisions: divisions,
          label: '$wordDeger',
          onChanged: (value) =>
              setState(() => this.indexWordSlider = value.toInt())),
    );
  }
}
