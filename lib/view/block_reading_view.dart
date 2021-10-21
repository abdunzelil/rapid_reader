import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rapid_reader_app/api/pdf_api.dart';

import 'package:rapid_reader_app/db/books_database.dart';
import 'package:rapid_reader_app/model/book.dart';

class BlockReading extends StatefulWidget {
  final int indexInPage;
  final int idBook;
  final int pageNo;

  const BlockReading({
    Key? key,
    required this.indexInPage,
    required this.idBook,
    required this.pageNo,
  }) : super(key: key);

  @override
  _BlockReadingState createState() => _BlockReadingState(
        indexInPage,
        idBook,
        pageNo,
      );
}

class _BlockReadingState extends State<BlockReading>
    with WidgetsBindingObserver {
  late Book book;
  bool isLoading = false;
  int indexWordSlider = 0;
  int indexSpeedSlider = 0;

  int pageNo = 0;
  int wordDeger = 1;
  int speedDeger = 120;
  int idBook;

  int totalPage = 200;
  late List<String> listOfWord;

  int index = 0;

  Timer? timer;
  _BlockReadingState(
    this.index,
    this.idBook,
    this.pageNo,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
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
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      if (timer!.isActive == true) {
        stopTimer(prev: false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color(0xFF121212),
          body: isLoading
              ? Center(child: CircularProgressIndicator())
              : blockBody()),
    );
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

  Widget blockBody() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                buildSpeedSlider(),
              ],
            ),
            Column(
              children: [
                const Text("Num of Words display",
                    style: TextStyle(
                        color: Colors.orangeAccent,
                        fontFamily: "BebasNeue",
                        fontSize: 20)),
                buildWordSlider(),
              ],
            ),
          ],
        ),
        Center(
          child: Container(
            child: Text(
                (indexWordSlider == 0)
                    ? listOfWord[index]
                    : listOfWord[index] + " " + listOfWord[index + 1],
                style: const TextStyle(
                    color: Colors.white, fontSize: 30, fontFamily: "Roboto")),
          ),
        ),
        buildButton(),
      ]),
    );
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

  void stopTimer({
    bool prev = true,
  }) {
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
              primary: Colors.orangeAccent.withOpacity(0.7),
              side: BorderSide(
                  color: Colors.orangeAccent.withOpacity(0.7), width: 3)),
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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            primary: Colors.orangeAccent.withOpacity(0.7),
                            side: BorderSide(
                                color: Colors.orangeAccent.withOpacity(0.7),
                                width: 3)),
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
                              fontSize: 25,
                              color: Colors.orangeAccent.withOpacity(0.7),
                              fontFamily: "BebasNeue"),
                        )),
                    SizedBox(
                      width: 15,
                    ),
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            primary: Colors.orange,
                            side: BorderSide(
                                color: Colors.orangeAccent.withOpacity(0.7),
                                width: 3)),
                        onPressed: () {
                          stopTimer();
                        },
                        child: Text("Previous Word",
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.orangeAccent.withOpacity(0.7),
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
                                      color:
                                          Colors.orangeAccent.withOpacity(0.7),
                                      width: 3)),
                              onPressed: () async {
                                await BooksDatabase.instance.update(book.copy(
                                    indexInPage: index, pageNo: pageNo));
                              },
                              child: Text("Save Progress",
                                  style: TextStyle(
                                      fontSize: 25,
                                      color:
                                          Colors.orangeAccent.withOpacity(0.7),
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
                        height: 20,
                      ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: LinearProgressIndicator(
                    minHeight: 5,
                    color: Colors.orangeAccent,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    value: (book.pageNo / book.totalPage),
                  ),
                )
              ],
            )
          : Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
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
        thumbColor: Colors.purpleAccent,
        activeColor: Colors.orangeAccent.withOpacity(0.3),
        inactiveColor: Colors.purpleAccent.withOpacity(0.5),
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
    return RotatedBox(
      quarterTurns: 1,
      child: Container(
        width: 80,
        child: Slider(
            thumbColor: Colors.purpleAccent,
            inactiveColor: Colors.purpleAccent.withOpacity(0.5),
            activeColor: Colors.orangeAccent.withOpacity(0.3),
            value: indexWordSlider.toDouble(),
            max: max,
            min: min,
            divisions: divisions,
            label: '$wordDeger',
            onChanged: (value) =>
                setState(() => this.indexWordSlider = value.toInt())),
      ),
    );
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
}
