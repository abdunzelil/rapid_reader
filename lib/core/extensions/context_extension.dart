import 'package:flutter/material.dart';
import 'package:rapid_reader_app/core/theme/custom_text_theme.dart';

extension ContextExtension on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
  bool get isKeyboardOpen => MediaQuery.of(this).viewInsets.bottom != 0;
  TextTheme get textTheme => CustomTextTheme(this);
}
