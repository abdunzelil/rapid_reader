import 'package:flutter/material.dart';

class AppConstants {
  static AppConstants? _instace;
  static AppConstants get instance {
    _instace ??= AppConstants._init();
    return _instace!;
  }

  AppConstants._init();
  static const supportedLangs = ['en', 'tr'];

  static const supportedLocales = [
    AppConstants.enLocale,
    AppConstants.trLocale,
  ];

  static const trLocale = Locale("tr", "TR");
  static const enLocale = Locale("en", "US");
}
