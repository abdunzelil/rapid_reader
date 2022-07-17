import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapid_reader_app/data/enums/modify_page_num.dart';
import 'package:rapid_reader_app/data/enums/set_font_size.dart';
import 'package:rapid_reader_app/service/pdf_service.dart';
import 'package:rapid_reader_app/data/db/books_database.dart';
import 'package:rapid_reader_app/data/model/book.dart';
import 'package:rapid_reader_app/presentation/view/views.dart';
import 'package:rapid_reader_app/helper/mili_second_calculator.dart';

class BookController extends SuperController {
  RxString route = "".obs;
  Timer? timer;
  List<String> listOfWord = [];
  late Book book;
  RxBool isContVisible = true.obs;
  var changeName = TextEditingController();
  var totalPage = 200.obs;
  RxBool isEditing = false.obs;
  int index = 0;
  RxBool isLoading = false.obs;
  RxBool areBooksLoading = false.obs;
  RxString blockStr = "".obs;
  RxInt wordDeger = 1.obs;
  RxInt speedDeger = 120.obs;
  RxInt curIndex = 0.obs;
  RxString bookName = "".obs;
  RxString firstFree = "".obs;
  RxString thirdFree = "".obs;
  RxString secFree = "".obs;
  RxString fourthFree = "".obs;
  late InterAdd interAdd;

  RxInt fontSize = 28.obs;

  var books = <Book>[].obs;
  RxBool isTimerRunning = false.obs;
  late int idBook;
  late int pageNo;
  var indexWordSlider = 0.obs;
  var indexSpeedSlider = 0.obs;

  Future<void> passData({required Book book}) async {
    isLoading.value = true;
    this.book = book;
    idBook = book.id!;
    pageNo = book.pageNo;
    index = book.indexInPage;
    totalPage.value = book.totalPage;
    listOfWord = await PDFService.pdfToStr(File(book.path), pageNo);
    if (route.value == "block") {
      blockStr.value = updateBlockString();
    } else {
      updateFreeStr();
    }
    if (pageNo == 1 && index == 0) {
      totalPage.value = PDFService.getTotpage();
      BooksDatabase.instance.update(book.copy(totalPage: totalPage.value));
      getBooks();
    }
    interAdd = InterAdd();
    isLoading.value = false;
  }

  @override
  void onInit() {
    getBooks();
    super.onInit();
  }

  void modifyPagenum(ModifyPageNum x) {
    if (x == ModifyPageNum.next) {
      if (pageNo < totalPage.value) {
        index = 0;
        pageNo++;
        changeList(false);
      }
    } else {
      if (pageNo > 1) {
        index = 0;
        pageNo--;
        changeList(false);
      }
    }
  }

  void setFontSize(SetFontSize x) {
    if (x == SetFontSize.up) {
      fontSize.value++;
    } else {
      fontSize.value--;
    }
  }

  void getBooks() async {
    areBooksLoading.value = true;
    books.clear();
    List<Book> tempBooks = await BooksDatabase.instance.getAllBooks();
    for (var book in tempBooks) {
      books.add(book);
    }
    areBooksLoading.value = false;
  }

  void changeIsVisible() {
    isContVisible.value = !isContVisible.value;
  }

  void setIsEditing(bool isEditing) {
    this.isEditing.value = isEditing;
  }

  void setIndexWord(int indexWord) {
    indexWordSlider.value = indexWord;
    wordDeger.value = indexWord + 1;
    if (route.value == "block") {
      blockStr.value = updateBlockString();
    } else {
      updateFreeStr();
    }
  }

  void setIndexSpeed(int indexSpeed) {
    indexSpeedSlider.value = indexSpeed;
    speedDeger.value = indexSpeed * 30 + 120;
  }

  void setWordDeger(int wordDeger) {
    this.wordDeger.value = wordDeger;
  }

  void setSpeedDeger(int speedDeger) {
    this.speedDeger.value = speedDeger;
  }

  void setCurIndex(int curIndex) {
    this.curIndex.value = curIndex;
  }
  void setIsTimerRunning(bool isRunning) {
    isTimerRunning.value = isRunning;
  }

  void setRoute(String route) {
    this.route.value = route;
  }

  void updateBook(
      {int? indexInPage,
      String? name,
      int? pageNo,
      int? totalPage,
      String? path}) async {
    BooksDatabase.instance.update(book.copy(
        indexInPage: indexInPage,
        pageNo: pageNo,
        name: name,
        totalPage: totalPage,
        path: path));
  }

  void startTimer() {
    isTimerRunning.value = true;
    timer = Timer.periodic(
        Duration(
            milliseconds:
                miliSecondCalculator(wordDeger.value, speedDeger.value)), (_) {
      if (wordDeger.value == 1) {
        if (index <= (listOfWord.length - 2)) {
          index++;
          refreshText();
        } else {
          if (pageNo < totalPage.value) {
            pageNo++;
            index = 0;
            changeList(true);
          } else {
            stopTimer;
          }
        }
      } else {
        if (index <= (listOfWord.length - 4)) {
          index = index + 2;
          refreshText();
        } else if (index <= (listOfWord.length - 3)) {
          listOfWord.add(" ");
          index = index + 2;
          refreshText();
        } else {
          if (pageNo < totalPage.value) {
            pageNo++;
            index = 0;
            changeList(true);
          } else {
            stopTimer;
          }
        }
      }
    });
  }

  void refreshText() {
    if (route.value == "block") {
      blockStr.value = updateBlockString();
    } else {
      updateFreeStr();
    }
  }

  void changeList(bool oto) async {
    if (pageNo % 5 == 4) {
      interAdd.showInterstitialAd();
      if (oto == true) {
        stopTimer();
      }
      isLoading.value = true;

      listOfWord = await PDFService.pdfToStr(File(book.path), pageNo);
      refreshText();
      isLoading.value = false;
    } else {
      if (oto == true) {
        timer!.cancel();
        isLoading.value = true;

        listOfWord = await PDFService.pdfToStr(File(book.path), pageNo);
        refreshText();
        isLoading.value = false;
        startTimer();
      } else {
        isLoading.value = true;

        listOfWord = await PDFService.pdfToStr(File(book.path), pageNo);
        refreshText();
        isLoading.value = false;
      }
    }
  }

  void stopTimer() {
    if (timer != null) {
      timer!.cancel();
    }
    
    isTimerRunning.value = false;
  }

  void prevWord() {
    if (index > 0) {
      index--;
    }

    refreshText();
  }

  

  void updateFreeStr() {
    firstFree.value = listOfWord.sublist(0, index).join(" ") + " ";
    secFree.value = listOfWord[index];

    thirdFree.value = (wordDeger.value == 1) ? "" : listOfWord[index + 1];
    fourthFree.value = (wordDeger.value == 1)
        ? " " + listOfWord.sublist(index + 1).join(' ')
        : " " + listOfWord.sublist(index + 2).join(' ');
  }

  String updateBlockString() {
    return (wordDeger.value == 1)
        ? listOfWord[index]
        : listOfWord[index] + " " + listOfWord[index + 1];
  }

  Future pickFile() async {
    String fileName;
    int pageNo = 1;
    int indexInPage = 0;

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result == null) return null;

    var file = result.files.first;
    fileName = file.name.replaceAll(".pdf", "");

    String path = file.path ?? " ";

    BooksDatabase.instance.create(Book(
      name: fileName,
      indexInPage: indexInPage,
      path: path,
      pageNo: pageNo,
      totalPage: 200,
    ));
    getBooks();
  }

  @override
  void onDetached() {
  }

  @override
  void onInactive() {
    if ((timer?.isActive ?? false) == true) {
      stopTimer();
    }
  }

  @override
  void onPaused() {
    if ((timer?.isActive ?? false) == true) {
      stopTimer();
    }
  }

  @override
  void onResumed() {
  }
}
