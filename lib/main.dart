import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapid_reader_app/view/home_view.dart';

main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(home: HomePage(), debugShowCheckedModeBanner: false);
  }
}
