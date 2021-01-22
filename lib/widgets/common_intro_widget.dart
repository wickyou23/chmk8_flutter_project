import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';

class CommonIntroWidget extends StatelessWidget {
  final Key key;
  final String assetImage;
  final double widthImage;
  final double ratioImage;
  final String description;
  final String titleButton;
  final Function onPressed;

  CommonIntroWidget({
    @required this.assetImage,
    @required this.widthImage,
    @required this.description,
    @required this.titleButton,
    this.key,
    this.ratioImage = 1,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        key: this.key,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Image.asset(
              this.assetImage,
              fit: BoxFit.fitHeight,
              width: this.widthImage,
              height: this.ratioImage * this.widthImage,
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Text(
              this.description,
              style: context.theme.textTheme.headline5.copyWith(
                color: Colors.grey[900],
                fontSize: 18,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 30),
          Container(
            width: context.media.size.width - 50,
            height: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: RaisedButton(
                child: Text(
                  this.titleButton,
                  style: context.theme.textTheme.button.copyWith(
                    color: Colors.white,
                  ),
                ),
                color: ColorExt.colorWithHex(0x098EF5),
                onPressed: this.onPressed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
