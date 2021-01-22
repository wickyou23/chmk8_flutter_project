import 'package:flutter/material.dart';
import '../utils/extension.dart';

enum CustomTextFormFieldType { normalStyle, greenStyle }

extension CustomTextFormFieldTypeExt on CustomTextFormFieldType {
  Color get titleColor {
    switch (this) {
      case CustomTextFormFieldType.greenStyle:
        return Colors.white;
      default:
        return ColorExt.colorWithHex(0x4F4F4F);
    }
  }

  Color get textColor {
    switch (this) {
      case CustomTextFormFieldType.greenStyle:
        return Colors.white;
      default:
        return Colors.black;
    }
  }

  Color get placeHolderColor {
    switch (this) {
      case CustomTextFormFieldType.greenStyle:
        return Colors.white60;
      default:
        return Colors.grey;
    }
  }

  Color get cursorColor {
    switch (this) {
      case CustomTextFormFieldType.greenStyle:
        return Colors.white;
      default:
        return ColorExt.colorWithHex(0x12B3FF);
    }
  }

  bool get isFilledTextField {
    return this == CustomTextFormFieldType.greenStyle;
  }
}
