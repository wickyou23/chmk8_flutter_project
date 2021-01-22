import 'package:flutter/material.dart';

extension TextExt on Text {
  Size get textSize {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: this.data, style: this.style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  Size getTextSize(double width) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: this.data, style: this.style),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: width);
    return textPainter.size;
  }
}