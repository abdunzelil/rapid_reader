import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:rapid_reader_app/db/books_database.dart';
import 'package:rapid_reader_app/model/book.dart';
import 'package:rapid_reader_app/state/book_controller.dart';
import 'package:rapid_reader_app/view/block_reading_view.dart';
import 'package:rapid_reader_app/view/free_reading_view.dart';

class LibraryPage extends StatelessWidget {
  LibraryPage({
    Key? key,
  }) : super(key: key);
  final state = Get.find<BookController>();

  int curIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        return Scaffold(
          backgroundColor: const Color(0xFF121212),
          appBar: AppBar(
              actions: [
                DropdownButtonHideUnderline(
                  child: DropdownButton(
                    dropdownColor: Colors.black,
                    iconEnabledColor: Colors.white,
                    value: state.route.value,
                    items: [
                      dropdownMenuItem(text: "Block Mode", value: "block"),
                      dropdownMenuItem(text: "Shadow Mode", value: "shadow"),
                      dropdownMenuItem(text: "Chasing Mode", value: "chasing"),
                    ],
                    onChanged: (String? value) {
                      state.setRoute(value ?? "");
                    },
                  ),
                ),
                IconButton(
                    tooltip: "Add Book",
                    onPressed: () {
                      state.pickFile();
                    },
                    icon: const Icon(
                      Icons.add_box_outlined,
                      size: 30,
                      color: Colors.orangeAccent,
                    ))
              ],
              backgroundColor: Colors.white.withOpacity(0.2),
              title: const Text("Library",
                  style: TextStyle(
                      fontSize: 30,
                      fontFamily: "BebasNeue",
                      color: Colors.orangeAccent))),
          body: Center(
            child: state.areBooksLoading.value
                ? CircularProgressIndicator()
                : state.books.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'No Books',
                            style: TextStyle(
                                color: Colors.orangeAccent,
                                fontSize: 40,
                                fontFamily: "BebasNeue"),
                          ),
                          Text(
                              "You can upload a pdf file from the top right button",
                              style: TextStyle(
                                  color: Colors.white,
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
                fontSize: 20, fontFamily: "BebasNeue", color: Colors.white)),
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
                  side:
                      BorderSide(color: Colors.purpleAccent.withOpacity(0.8))),
              shadowColor: Colors.blueGrey,
              color: Colors.white.withOpacity(0.1),
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
                    backgroundColor: Colors.white.withOpacity(0.2),
                    color: Colors.orangeAccent,
                    value: (book.pageNo / book.totalPage)),
                title: Obx(() {
                  return editableNameOfBook(book, index);
                }),
                trailing: Wrap(
                  spacing: 0,
                  children: [
                    IconButton(
                        onPressed: () {
                          curIndex = index;

                          state.setIsEditing(true);
                        },
                        icon: Icon(Icons.edit, color: Colors.white)),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.white),
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
    if (state.isEditing.value && index == curIndex) {
      return TextField(
        controller: state.changeName,
        style: TextStyle(color: Colors.white),
        onSubmitted: (newValue) async {
          if (newValue != "" && newValue != " ") {
            await BooksDatabase.instance.update(book.copy(name: newValue));
            state.getBooks();
          }
          state.setIsEditing(false);
        },
        autofocus: true,
      );
    }
    return Text(
      book.name,
      style: TextStyle(color: Colors.white),
    );
  }
}
