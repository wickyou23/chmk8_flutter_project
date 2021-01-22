import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';

extension ScaffoldStateExt on ScaffoldState {
  void showCSSnackBar(
    String title, {
    Duration duration = const Duration(seconds: 4),
  }) {
    this.showSnackBar(
      SnackBar(
        content: Text(
          title,
          style: this.context.theme.textTheme.headline5.copyWith(
                fontSize: 14,
                color: Colors.white,
              ),
        ),
        duration: duration,
      ),
    );
  }
}
