import 'package:flutter/material.dart';
import '../constant.dart';

extension ColorExt on Color {
  Color withPercentAlpha(double percent) {
    if (percent >= 1) {
      return this;
    }

    return this.withAlpha((255 * percent).toInt());
  }

  static Color get mainColor {
    return Constaint.mainColor;
  }

  static Color colorWithHex(int hexColor) {
    return Color.fromARGB(
      0xFF,
      (hexColor >> 16) & 0xFF,
      (hexColor >> 8) & 0xFF,
      hexColor & 0xFF,
    );
  }

  static Color get myBlack {
    return ColorExt.colorWithHex(0x2C2C2C);
  }
}