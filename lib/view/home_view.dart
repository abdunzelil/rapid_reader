import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapid_reader_app/state/book_controller.dart';

import 'library_view.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final BookController state = Get.put(BookController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: SafeArea(child: buildHomeBody()),
      ),
    );
  }

  Widget buildButton(
    String text,
  ) {
    return OutlinedButton(
        onPressed: () async {
          if (text == "BLOCK MODE") {
            state.setRoute("block");
          } else {
            if (text == "SHADOW MODE") {
              state.setRoute("shadow");
            } else {
              state.setRoute("chasing");
            }
          }
          Get.to(() => LibraryPage());
        },
        child: Text(
          text,
          style: const TextStyle(fontSize: 40, fontFamily: "BebasNeue"),
        ),
        style: OutlinedButton.styleFrom(
            primary: Colors.orangeAccent,
            side: const BorderSide(color: Colors.orangeAccent, width: 3)));
  }

  Widget buildHomeBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    icon: Icon(Icons.info_outline,
                        color: Colors.orangeAccent, size: 30),
                    onPressed: () {
                      Get.defaultDialog(
                          backgroundColor: Colors.orangeAccent,
                          barrierDismissible: true,
                          title: "GENERAL INFORMATION",
                          titleStyle:
                              TextStyle(fontFamily: "BebasNeue", fontSize: 25),
                          content: Text(
                            "●This app was created to enable you to carry out your readings with a deeper focus, thus increasing your comprehension rate and allowing you to finish your books in a shorter time.\n ●The books you want to read must be in pdf format.\n ●You cannot read pdf files whose text consists of images. If \"Blank Page\" is written on the screen while reading, it means that there is no text on that page.",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "LibreBaskerville",
                                fontWeight: FontWeight.bold),
                          ));
                    }))),
        SizedBox(
          height: 70,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Image.asset('assets/images/rapidreaderlogo.jpg'),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text("Read an entire book in a day!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontFamily: "Damion",
            )),
        const SizedBox(
          height: 100,
        ),
        buildButton("BLOCK MODE"),
        const SizedBox(
          height: 20,
        ),
        buildButton("SHADOW MODE"),
        const SizedBox(
          height: 20,
        ),
        buildButton("CHASING MODE"),
      ],
    );
  }
}
