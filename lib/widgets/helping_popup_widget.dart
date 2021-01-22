import 'package:chkm8_app/utils/constant.dart';
import 'package:chkm8_app/utils/extension.dart';
import 'package:chkm8_app/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';

class HelpingPopupWidget extends StatefulWidget {
  final List<String> titles;
  final List<String> messages;
  final Color btnColor;

  HelpingPopupWidget({
    @required this.messages,
    this.titles,
    this.btnColor,
  });

  @override
  _HelpingPopupWidgetState createState() => _HelpingPopupWidgetState();
}

class _HelpingPopupWidgetState extends State<HelpingPopupWidget> {
  List<String> _guideStr;
  List<String> _titleStr;

  @override
  void initState() {
    _guideStr = this.widget.messages;
    _titleStr = this.widget.titles;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.media.size.width - 90,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 32),
          Image.asset(
            'assets/images/ic_help_circle_larger.png',
            width: 63,
            height: 63,
          ),
          if (_titleStr != null)
            Container(
              padding: const EdgeInsets.only(top: 13),
              child: Text(
                _titleStr.removeAt(0),
                textAlign: TextAlign.center,
                style: context.theme.textTheme.headline5.copyWith(
                  fontSize: 16,
                  color: Constaint.defaultTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          SizedBox(height: 13),
          Container(
            alignment: Alignment.center,
            child: Text(
              _guideStr.removeAt(0),
              textAlign: TextAlign.center,
              style: context.theme.textTheme.headline5.copyWith(
                fontSize: 16,
                color: ColorExt.colorWithHex(0x333333),
              ),
            ),
          ),
          SizedBox(height: 30),
          CustomButtonWidget(
            title: 'Ok, Got it!',
            btnColor: this.widget.btnColor ?? Constaint.mainColor,
            onPressed: () {
              if (_guideStr.isEmpty) {
                context.navigator.pop();
              } else {
                setState(() {});
              }
            },
          ),
          SizedBox(height: 38),
        ],
      ),
    );
  }
}
