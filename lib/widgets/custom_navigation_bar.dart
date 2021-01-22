import 'package:chkm8_app/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';

class CustomNavigationBar extends StatelessWidget {
  static final double heightNavBar = 64;

  final String navTitle;
  final Color navTitleColor;
  final Color backgroundColor;
  final Widget rightBarIcon;
  final String bgImage;
  final bool isShowBack;
  final Function rightBarOnPressed;
  final Function backButtonOnPressed;

  CustomNavigationBar({
    @required this.navTitle,
    this.navTitleColor,
    this.backgroundColor = Colors.transparent,
    this.rightBarIcon,
    this.rightBarOnPressed,
    this.bgImage,
    this.backButtonOnPressed,
    this.isShowBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      width: context.media.size.width,
      height: CustomNavigationBar.heightNavBar + context.media.viewPadding.top,
      child: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(top: context.media.viewPadding.top),
        constraints: BoxConstraints(
          minHeight:
              CustomNavigationBar.heightNavBar,
        ),
        decoration: _getBoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Text(
                  this.navTitle,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: context.theme.appBarTheme.textTheme.headline5.copyWith(
                    fontSize: 21,
                    color: this.navTitleColor ?? Constaint.mainColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                color: Colors.transparent,
                child: Row(
                  children: <Widget>[
                    if (this.isShowBack)
                      CupertinoButton(
                        padding: const EdgeInsets.only(
                          top: 16,
                          bottom: 16,
                          left: 0,
                          right: 10,
                        ),
                        minSize: 20,
                        child: ImageIcon(
                          AssetImage('assets/images/ic_back.png'),
                          color: Colors.black,
                          size: 22,
                        ),
                        onPressed: () {
                          if (this.backButtonOnPressed != null) {
                            this.backButtonOnPressed();
                          } else {
                            context.navigator.pop();
                          }
                        },
                      ),
                    Expanded(
                      child: Container(),
                    ),
                    if (this.rightBarIcon != null)
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 16,
                        ),
                        minSize: 20,
                        child: this.rightBarIcon,
                        onPressed: this.rightBarOnPressed,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _getBoxDecoration() {
    return (this.bgImage != null)
        ? BoxDecoration(
            image: DecorationImage(
                image: AssetImage(this.bgImage), fit: BoxFit.cover),
          )
        : BoxDecoration(
            color: this.backgroundColor,
          );
  }
}
