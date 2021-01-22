import 'package:chkm8_app/utils/extension.dart';
import 'package:flutter/material.dart';

enum Gender { male, female, other }

extension GenderExt on Gender {
  static Gender initRawValue(String rawValue) {
    switch (rawValue) {
      case 'MALE':
        return Gender.male;
      case 'FEMALE':
        return Gender.female;
      case 'OTHER':
        return Gender.other;
      default:
        return null;
    }
  }

  String get rawValue {
    switch (this) {
      case Gender.male:
        return 'MALE';
      case Gender.female:
        return 'FEMALE';
      case Gender.other:
        return 'OTHER';
      default:
        return null;
    }
  }

  String get title {
    switch (this) {
      case Gender.male:
        return "Male";
      case Gender.female:
        return "Female";
      case Gender.other:
        return "Others";
      default:
        return null;
    }
  }

  String get icon {
    switch (this) {
      case Gender.male:
        return "assets/images/ic_mars.png";
      case Gender.female:
        return "assets/images/ic_woman.png";
      case Gender.other:
        return "assets/images/ic_transgender.png";
      default:
        return null;
    }
  }

  Color get color {
    return ColorExt.colorWithHex(0x9B9B9B);
  }
}
