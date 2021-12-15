import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "";
    } else if (Platform.isIOS) {
      return "";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-5452704472960039/1038877285";
    } else if (Platform.isIOS) {
      return "";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
