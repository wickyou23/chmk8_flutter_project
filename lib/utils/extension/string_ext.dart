import 'package:chkm8_app/utils/constant.dart';

extension StringExt on String {
  bool get validatorPhoneNumber {
    if (this.isEmpty) {
      return false;
    }
    bool valid = false;
    for (var regex in Constaint.regexPhoneNumer) {
      valid = this.contains(RegExp(regex, multiLine: true));
      if (valid) {
        return valid;
      }
    }

    return valid;
  }

  String toCapitalizedCase() {
    var subStrings = this.split(' ');
    String fullString = '';
    for (var item in subStrings) {
      if (item.isEmpty) {
        continue;
      }

      fullString += ((fullString.isEmpty ? '' : ' ') +
          item.replaceRange(0, 1, item[0].toUpperCase()));
    }

    return fullString;
  }

  String toFirstUpperCase() {
    if (this.isEmpty) return this;
    return this.replaceRange(0, 1, this[0].toUpperCase());
  }
}
