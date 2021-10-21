import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_text/pdf_text.dart';

import 'package:rapid_reader_app/db/books_database.dart';
import 'package:rapid_reader_app/model/book.dart';
import 'package:rapid_reader_app/view/block_reading_view.dart';
import 'package:rapid_reader_app/view/free_reading_view.dart';

class LibraryPage extends StatefulWidget {
  final route;
  const LibraryPage({Key? key, this.route}) : super(key: key);

  @override
  _LibraryPageState createState() => _LibraryPageState(this.route);
}

class _LibraryPageState extends State<LibraryPage> {
  late List<Book> books;
  bool isLoading = false;
  String route = "free";
  int totalIndex = 10000;
  int curIndex = 0;
  bool _isEditingText = false;
  late TextEditingController _editingController;
  int menuVal = 0;
  _LibraryPageState(this.route);
  @override
  void initState() {
    super.initState();
    refreshBooks();
    _editingController = TextEditingController();
  }

  Future refreshBooks() async {
    setState(() => isLoading = true);
    books = await BooksDatabase.instance.getAllBooks();
    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        appBar: AppBar(
            actions: [
              DropdownButtonHideUnderline(
                child: DropdownButton(
                  dropdownColor: Colors.black,
                  iconEnabledColor: Colors.white,
                  value: route,
                  items: [
                    DropdownMenuItem(
                        child: Text("   Block Reading",
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: "BebasNeue",
                                color: Colors.white)),
                        value: "block"),
                    DropdownMenuItem(
                      child: Text("Shadow Reading",
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: "BebasNeue",
                              color: Colors.white)),
                      value: "free",
                    )
                  ],
                  onChanged: (String? value) {
                    setState(() {
                      route = value ?? "";
                    });
                  },
                ),
              ),
              IconButton(
                  tooltip: "Add Book",
                  onPressed: () {
                    pickFile();
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
          child: isLoading
              ? CircularProgressIndicator()
              : books.isEmpty
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
      ),
    );
  }

  Widget buildBooks() {
    return ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side:
                      BorderSide(color: Colors.purpleAccent.withOpacity(0.8))),
              shadowColor: Colors.blueGrey,
              color: Colors.white.withOpacity(0.1),
              child: ListTile(
                onTap: () async {
                  if (route == "free") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FreeReading(
                                  indexInPage: book.indexInPage,
                                  idBook: book.id!,
                                  pageNo: book.pageNo,
                                ))).then((value) => refreshBooks());
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BlockReading(
                                  indexInPage: book.indexInPage,
                                  idBook: book.id!,
                                  pageNo: book.pageNo,
                                ))).then((value) => refreshBooks());
                  }
                },
                leading: CircularProgressIndicator(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    color: Colors.orangeAccent,
                    value: (book.pageNo / book.totalPage)),
                title: editableNameOfBook(book, index),
                trailing: Wrap(
                  spacing: 0,
                  children: [
                    IconButton(
                        onPressed: () {
                          curIndex = index;
                          setState(() {
                            _isEditingText = true;
                          });
                        },
                        icon: Icon(Icons.edit, color: Colors.purpleAccent)),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.purpleAccent),
                      onPressed: () async {
                        await BooksDatabase.instance.delete(book.id!);
                        refreshBooks();
                      },
                    ),
                  ],
                ),
              ));
        });
  }

  List<String> stringParser(String text) {
    List<String> tempList = text.trim().split(RegExp('\\s+'));
    tempList.removeWhere((element) => element == '');
    tempList.add("FINISHED!");
    tempList.add("FINISHED!");
    totalIndex = tempList.length;
    return tempList;
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

    final newFile = await saveFilePermanently(file);
    String path = newFile.path;
    BooksDatabase.instance.create(Book(
      name: fileName,
      indexInPage: indexInPage,
      path: path,
      pageNo: pageNo,
      totalPage: 200,
    ));
    refreshBooks();
  }

  Future<File> saveFilePermanently(PlatformFile file) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final newFile = File('${appStorage.path}/${file.name}');
    return File(file.path!).copy(newFile.path);
  }

  Widget editableNameOfBook(Book book, int index) {
    if (_isEditingText && index == curIndex) {
      return TextField(
        style: TextStyle(color: Colors.white),
        onSubmitted: (newValue) async {
          await BooksDatabase.instance.update(book.copy(name: newValue));
          setState(() {
            _isEditingText = false;
            refreshBooks();
          });
        },
        autofocus: true,
        controller: _editingController,
      );
    }
    return Text(
      book.name,
      style: TextStyle(color: Colors.white),
    );
  }
}
