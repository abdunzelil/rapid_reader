import 'dart:io';
import 'package:pdf_text/pdf_text.dart';

class PDFApi {
  static Future<List<String>> pdfToStr(File tempFile, int pageNo) async {
    PDFDoc doc = await PDFDoc.fromFile(tempFile);
    PDFPage page = doc.pageAt(pageNo);
    String pageText = await page.text;
    List<String> tempList = pageText.trim().split(RegExp('\\s+'));
    tempList.removeWhere((element) => element == '');
    if (tempList.isEmpty) {
      tempList.add("BLANKPAGE");
    }
    if (pageNo == 1) {
      tempList.add("${doc.length}");
    }

    return tempList;
  }
}
