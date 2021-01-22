import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';

class HomeNaviBar extends StatelessWidget {
  static final double heightNavBar = 70;

  final VoidCallback drawerPressed;
  final VoidCallback notiPressed;
  final Color tintColor;
  final String title;
  final Color backgroundColor;
  final bool hiddenNotification;

  HomeNaviBar({
    @required this.drawerPressed,
    @required this.notiPressed,
    this.tintColor = Colors.black,
    this.title = '',
    this.backgroundColor = Colors.transparent,
    this.hiddenNotification = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: this.backgroundColor,
      padding: EdgeInsets.only(
        top: context.media.viewPadding.top,
        left: 13,
        right: 13,
      ),
      height: HomeNaviBar.heightNavBar + context.media.viewPadding.top,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                this.drawerPressed();
              },
              iconSize: 35,
              color: this.tintColor,
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                this.title,
                style: context.theme.appBarTheme.textTheme.headline5.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 27,
                  color: this.tintColor,
                ),
              ),
            ),
          ),
          // if (!this.hiddenNotification)
          // IconButton(
          //   icon: ImageIcon(
          //     AssetImage('assets/images/ic_bell.png'),
          //   ),
          //   onPressed: () {
          //     this.notiPressed();
          //   },
          //   iconSize: 35,
          //   color: this.tintColor,
          // ),
          // if (this.hiddenNotification)
          Container(
            width: 45,
            child: null,
          ),
        ],
      ),
    );
  }
}
