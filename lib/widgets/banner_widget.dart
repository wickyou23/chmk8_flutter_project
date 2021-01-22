import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:chkm8_app/utils/extension.dart';

class BannerWidget extends StatefulWidget {
  final Key key;
  final String title;
  final Widget child;

  BannerWidget({this.key, this.title, @required this.child}) : super(key: key);

  @override
  BannerWidgetState createState() => BannerWidgetState();
}

class BannerWidgetState extends State<BannerWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;
  Timer _autoHideTimer;
  bool isShowing = false;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );

    _animationController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _autoHideTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _animation = _animationController.drive(
      Tween<double>(
        begin: -70,
        end: context.media.viewPadding.top + 20,
      ),
    );

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          this.widget.child,
          Positioned(
            width: context.media.size.width,
            height: 50,
            top: _animation.value,
            child: Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                color: ColorExt.colorWithHex(0xDDF9D3),
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Text(
                    this.widget.title,
                    style: context.theme.textTheme.headline5.copyWith(
                      color: ColorExt.colorWithHex(0x219653),
                      fontSize: 18,
                    ),
                  ),
                  Expanded(child: Container()),
                  IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _animationController.reverse();
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showBanner({Duration hideInDuration}) {
    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, 1);
    _animationController.animateWith(simulation);
    this.isShowing = true;
    if (hideInDuration != null) {
      _autoHideTimer?.cancel();
      _autoHideTimer = Timer(hideInDuration, () {
        if (_animationController.status == AnimationStatus.completed) {
          _animationController.reverse();
        }

        this.isShowing = false;
      });
    }
  }

  void forceHide() {
    _animationController.reset();
    this.isShowing = false;
  }
}
