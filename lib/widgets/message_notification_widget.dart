import 'package:chkm8_app/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';

class MessageNotification extends StatelessWidget {
  final String message;
  final VoidCallback onTap;

  const MessageNotification({
    Key key,
    this.message,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SafeArea(
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          child: ListTile(
            title: Text(
              message,
              style: context.theme.textTheme.headline5.copyWith(
                fontSize: 16,
                color: Constaint.defaultTextColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
