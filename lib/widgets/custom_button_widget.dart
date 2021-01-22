import 'package:chkm8_app/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';

enum CustomButtonType {
  filled,
  line,
}

class CustomButtonWidget extends StatelessWidget {
  final ValueKey key;
  final double width;
  final double height;
  final String title;
  final CustomButtonType type;
  final Function onPressed;
  final double radius;
  final Widget wTitle;
  final Color btnColor;
  final Color tintColor;

  CustomButtonWidget({
    this.key,
    this.width = 155,
    this.height = 46,
    this.title,
    @required this.onPressed,
    this.type = CustomButtonType.filled,
    this.radius,
    this.wTitle,
    this.btnColor,
    this.tintColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      height: this.height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(this.radius ?? this.height / 2),
        child: _buildButton(context),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    if (this.type == CustomButtonType.filled) {
      return FlatButton(
        child: this.wTitle ??
            Text(
              this.title,
              style: context.theme.textTheme.button.copyWith(
                color: Colors.white,
              ),
            ),
        color: this.btnColor ?? Constaint.mainColor,
        disabledColor: this.btnColor?.withPercentAlpha(0.5) ??
            Constaint.mainColor.withPercentAlpha(0.5),
        highlightColor: Colors.white.withPercentAlpha(0.2),
        splashColor: Colors.white.withPercentAlpha(0.3),
        onPressed: this.onPressed,
      );
    } else {
      return FlatButton(
        child: this.wTitle ??
            Text(
              this.title,
              style: context.theme.textTheme.button.copyWith(
                color: this.tintColor ?? Constaint.mainColor,
                fontWeight: FontWeight.bold,
              ),
            ),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1.0,
            color: this.tintColor ?? Constaint.mainColor,
          ),
          borderRadius: BorderRadius.circular(this.radius ?? this.height / 2),
        ),
        highlightColor: this.tintColor?.withPercentAlpha(0.2) ??
            Constaint.mainColor.withPercentAlpha(0.2),
        splashColor: this.tintColor?.withPercentAlpha(0.3) ??
            Constaint.mainColor.withPercentAlpha(0.3),
        onPressed: this.onPressed,
      );
    }
  }
}
