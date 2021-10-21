import 'package:flutter/material.dart';

import 'library_view.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  var pdfFile;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: buildHomeBody(context),
      ),
    );
  }

  Widget buildButton(String text, BuildContext context) {
    return OutlinedButton(
        onPressed: () async {
          if (text == "BLOCK READING") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => (const LibraryPage(
                          route: "block",
                        ))));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LibraryPage(
                          route: "free",
                        )));
          }
        },
        child: Text(
          text,
          style: const TextStyle(fontSize: 40, fontFamily: "BebasNeue"),
        ),
        style: OutlinedButton.styleFrom(
            primary: Colors.orangeAccent,
            side: const BorderSide(color: Colors.orangeAccent, width: 3)));
  }

  Widget buildHomeBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Image.asset('assets/images/rapidreaderlogo.png'),
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
        buildButton("BLOCK READING", context),
        const SizedBox(
          height: 20,
        ),
        buildButton("SHADOW READING", context),
      ],
    );
  }
}
