import 'package:flutter/material.dart';

extension MediaQueryDataExt on MediaQueryData {
  double get contentHeight {
    return this.size.height - this.padding.top;
  }
}