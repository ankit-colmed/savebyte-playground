import 'package:flutter/material.dart';

class Responsive {
  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getScaledValue(BuildContext context, double baseValue) {
    final screenWidth = MediaQuery.of(context).size.width;
    return baseValue * (screenWidth / 375); // 375 is base design width
  }

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600;
  }

  static EdgeInsets getScaledPadding(BuildContext context, double value) {
    return EdgeInsets.all(getScaledValue(context, value));
  }
}