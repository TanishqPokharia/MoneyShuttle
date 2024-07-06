import 'package:flutter/material.dart';

extension ResponsiveSize on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  double rSize(double val) => screenHeight * (val / 1000);
}

extension TextSizes on BuildContext {
  TextStyle? get textSmall => Theme.of(this).textTheme.titleSmall;
  TextStyle? get textMedium => Theme.of(this).textTheme.titleMedium;
  TextStyle? get textLarge => Theme.of(this).textTheme.titleLarge;
}

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  Color get backgroundColor => Theme.of(this).scaffoldBackgroundColor;
  Color? get iconColor => Theme.of(this).iconTheme.color;
}
