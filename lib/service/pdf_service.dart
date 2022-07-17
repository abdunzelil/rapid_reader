import 'dart:io';

import 'package:pdf_text/pdf_text.dart';

class PDFService {
  static int totalPage = 200;
  static int getTotpage() {
    return totalPage;
  }

  static Future<List<String>> pdfToStr(File tempFile, int pageNo) async {
    PDFDoc doc = await PDFDoc.fromFile(tempFile);
    PDFPage page = doc.pageAt(pageNo);
    String pageText = await page.text;
    List<String> tempList = pageText.trim().split(RegExp('\\s+'));
    tempList.removeWhere((element) => element == '');
    if (tempList.isEmpty) {
      tempList.add("BLANK");
      tempList.add("PAGE");
    }
    if (pageNo == 1) {
      totalPage = doc.length;
    }

    return tempList;
  }
}
