
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rapid_reader_app/constants/app_constants.dart';
import 'package:rapid_reader_app/core/config/config.dart';
import 'package:rapid_reader_app/localization/app_localization.dart';
import 'package:rapid_reader_app/presentation/view/home_view.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(builder: (context, child) {
      return GetMaterialApp(
          title: Config.title,
          localeResolutionCallback: localeResolutionCallback,
          supportedLocales: AppConstants.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: HomePage(),
          debugShowCheckedModeBanner: false);
    });
  }

  Locale localeResolutionCallback(
      Locale? locale, Iterable<Locale> supportedLocales) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return supportedLocale;
        }
      }
    }
    return supportedLocales.first;
  }
}
