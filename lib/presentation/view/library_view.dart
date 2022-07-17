import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:rapid_reader_app/data/db/books_database.dart';
import 'package:rapid_reader_app/data/model/book.dart';
import 'package:rapid_reader_app/localization/app_localization.dart';
import 'package:rapid_reader_app/state/book_controller.dart';

import 'package:rapid_reader_app/presentation/view/views.dart';

import '../../core/theme/palette.dart';

class LibraryPage extends StatelessWidget {
  LibraryPage({
    Key? key,
  }) : super(key: key);
  final state = Get.find<BookController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        return Scaffold(
          backgroundColor: Palette.backgroundColor,
          appBar: AppBar(
              actions: [
                DropdownButtonHideUnderline(
                  child: DropdownButton(
                    dropdownColor: Colors.black,
                    iconEnabledColor: Palette.label,
                    value: state.route.value,
                    items: [
                      dropdownMenuItem(
                          text: context.translate("BLOCK_MODE"),
                          value: "block"),
                      dropdownMenuItem(
                          text: context.translate("SHADOW_MODE"),
                          value: "shadow"),
                      dropdownMenuItem(
                          text: context.translate("CHASING_MODE"),
                          value: "chasing"),
                    ],
                    onChanged: (String? value) {
                      state.setRoute(value ?? "");
                    },
                  ),
                ),
                IconButton(
                    tooltip: context.translate("ADD_BOOK"),
                    onPressed: () {
                      state.pickFile();
                    },
                    icon: Icon(Icons.add_box_outlined,
                        size: 30, color: Palette.primaryColor))
              ],
              backgroundColor: Palette.label.withOpacity(0.2),
              title: Text(context.translate("LIBRARY"),
                  style: TextStyle(
                      fontSize: 30,
                      fontFamily: "BebasNeue",
                      color: Palette.primaryColor))),
          body: Center(
            child: state.areBooksLoading.value
                ? const CircularProgressIndicator()
                : state.books.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            context.translate("NO_BOOKS"),
                            style: TextStyle(
                                color: Palette.primaryColor,
                                fontSize: 40,
                                fontFamily: "BebasNeue"),
                          ),
                          Text(context.translate("YOU_CAN_UPLOAD"),
                              style: TextStyle(
                                  color: Palette.label,
                                  fontSize: 20,
                                  fontFamily: "BebasNeue"))
                        ],
                      )
                    : buildBooks(),
          ),
        );
      }),
    );
  }

  DropdownMenuItem<String> dropdownMenuItem(
      {required String text, required String value}) {
    return DropdownMenuItem(
        child: Text(text,
            style: TextStyle(
                fontSize: 20, fontFamily: "BebasNeue", color: Palette.label)),
        value: value);
  }

  Widget buildBooks() {
    return ListView.builder(
        itemCount: state.books.length,
        itemBuilder: (context, index) {
          final book = state.books.elementAt(index);
          return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: BorderSide(
                      color: Palette.secondaryColor.withOpacity(0.8))),
              shadowColor: Colors.blueGrey,
              color: Palette.label.withOpacity(0.1),
              child: ListTile(
                onTap: () {
                  state.passData(book: book);
                  if (state.route.value == "chasing" ||
                      state.route.value == "shadow") {
                    Get.to(() => FreeReading())!.then((value) {
                      state.stopTimer();
                      state.getBooks();
                    });
                  } else {
                    Get.to(() => BlockReading())!.then((value) {
                      state.stopTimer();
                      state.getBooks();
                    });
                  }
                },
                leading: CircularProgressIndicator(
                    backgroundColor: Palette.label.withOpacity(0.2),
                    color: Palette.primaryColor,
                    value: (book.pageNo / book.totalPage)),
                title: Obx(() {
                  return editableNameOfBook(book, index);
                }),
                trailing: Wrap(
                  spacing: 0,
                  children: [
                    IconButton(
                        onPressed: () {
                          state.setCurIndex(index);
                          state.setIsEditing(true);
                        },
                        icon: Icon(Icons.edit, color: Palette.label)),
                    IconButton(
                      icon: Icon(Icons.delete, color: Palette.label),
                      onPressed: () async {
                        File(book.path).delete();
                        await BooksDatabase.instance.delete(book.id!);
                        state.getBooks();
                      },
                    ),
                  ],
                ),
              ));
        });
  }

  Widget editableNameOfBook(Book book, int index) {
    if (state.isEditing.value && index == state.curIndex.value) {
      return TextField(
        controller: state.changeName,
        style: TextStyle(color: Palette.label),
        onSubmitted: (newValue) async {
          if (newValue != "" && newValue != " ") {
            await BooksDatabase.instance.update(book.copy(name: newValue));
            state.getBooks();
          }
          state.setIsEditing(false);
          state.changeName.text = "";
        },
        autofocus: true,
      );
    }
    return Text(
      book.name,
      style: TextStyle(color: Palette.label),
    );
  }
}
