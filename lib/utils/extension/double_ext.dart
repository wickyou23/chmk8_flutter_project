import 'dart:math';

extension DoubleExt on double {
  double toRadian() {
    return (this * pi) / 180;
  }

  String toCSStringAsFixed(int fractionDigits) {
    String starStr = '';
    int mod = this ~/ 10;
    if (mod != 0) {
      starStr = this.toStringAsFixed(fractionDigits);
    } else {
      starStr = this.toInt().toString();
    }

    return starStr;
  }
}
