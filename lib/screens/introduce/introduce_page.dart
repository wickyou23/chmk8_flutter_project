import 'package:chkm8_app/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';

class IntroducePage extends StatelessWidget {
  final String description;
  final String title;
  final Widget wtitle;
  final Widget wDescription;
  final ImageProvider image;
  final double ratio;

  IntroducePage({
    @required this.image,
    this.description,
    this.title = 'SaileBot',
    this.wtitle,
    this.wDescription,
    this.ratio = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      child: Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: this.ratio,
            child: Image(
              image: this.image,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                top: (context.media.size.width / (1080 / 925)) +
                    (context.isSmallDevice ? 0 : 33)),
            child: Column(
              children: <Widget>[
                _buildTitle(context),
                SizedBox(height: (context.isSmallDevice) ? 5 : 15),
                _buildDesciption(context),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    if (this.wtitle != null) {
      return this.wtitle;
    } else {
      return Text(
        this.title,
        textAlign: TextAlign.center,
        style: context.theme.appBarTheme.textTheme.headline6.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: (context.isSmallDevice) ? 20 : 21,
          color: Constaint.mainColor,
        ),
      );
    }
  }

  Widget _buildDesciption(BuildContext context) {
    if (this.wDescription != null) {
      return this.wDescription;
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: Text(
          this.description,
          style: context.theme.textTheme.headline5.copyWith(
            color: ColorExt.myBlack,
            fontSize: (context.isSmallDevice) ? 18 : 19,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}
