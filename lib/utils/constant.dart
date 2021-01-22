import 'package:flutter/material.dart';
import './extension.dart';

class Constaint {
  static const String passwordRex =
      '^(?=.*[a-z])(?=.*[0-9])(?=.*[!@#\$%^&*]).{8,}\$';
  static const String emailRex =
      '[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}';
  static final Color mainColor = ColorExt.colorWithHex(0x2F9D55);
  static final Color naviBarColor = ColorExt.colorWithHex(0x098EF5);
  static final Color defaultTextColor = ColorExt.colorWithHex(0x4F4F4F);
  static final Color scheduleRatingColor = ColorExt.colorWithHex(0x2D9CDB);
  static final Color rateYourDateColor = ColorExt.colorWithHex(0xF2994A);
  static final List<String> regexPhoneNumer = [
    r"^(\+\d{1,2}\s?)?1?\-?\.?\s?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$",
    r"^\s*(?:\+?(\d{1,3}))?[- (]*(\d{3})[- )]*(\d{3})[- ]*(\d{4})(?: *[x/#]{1}(\d+))?\s*$"
  ];
}
