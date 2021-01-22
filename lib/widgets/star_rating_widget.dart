import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StarRatingWidget extends StatefulWidget {
  final double starScore;
  final Function(int) onRating;

  StarRatingWidget({
    this.starScore = 0,
    this.onRating,
  });

  @override
  _StarRatingWidgetState createState() => _StarRatingWidgetState();
}

class _StarRatingWidgetState extends State<StarRatingWidget> {
  int _starScore;

  @override
  void initState() {
    _starScore = this.widget.starScore.round();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: (this.widget.onRating == null)
          ? IgnorePointer(
              child: _buildAllStar(),
            )
          : _buildAllStar(),
    );
  }

  Widget _buildAllStar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _starButton(
          key: ValueKey(1),
          isSeleted: _starScore >= 1,
          onPressed: () {
            _starScore = 1;
            setState(() {});
            _handleCallBack();
          },
        ),
        _starButton(
          key: ValueKey(2),
          isSeleted: _starScore >= 2,
          onPressed: () {
            _starScore = 2;
            setState(() {});
            _handleCallBack();
          },
        ),
        _starButton(
          key: ValueKey(3),
          isSeleted: _starScore >= 3,
          onPressed: () {
            _starScore = 3;
            setState(() {});
            _handleCallBack();
          },
        ),
        _starButton(
          key: ValueKey(4),
          isSeleted: _starScore >= 4,
          onPressed: () {
            _starScore = 4;
            setState(() {});
            _handleCallBack();
          },
        ),
        _starButton(
          key: ValueKey(5),
          isSeleted: _starScore >= 5,
          onPressed: () {
            _starScore = 5;
            setState(() {});
            _handleCallBack();
          },
        ),
      ],
    );
  }

  Widget _starButton({
    @required ValueKey key,
    @required bool isSeleted,
    Function onPressed,
  }) {
    return CupertinoButton(
      key: key,
      padding: EdgeInsets.zero,
      child: Image.asset(
        (isSeleted)
            ? 'assets/images/ic_star_selected.png'
            : 'assets/images/ic_star_unselected.png',
        width: 36,
        height: 36,
      ),
      onPressed: onPressed,
    );
  }

  void _handleCallBack() {
    Future.delayed(Duration(milliseconds: 100), () {
      this.widget.onRating(_starScore);
    });
  }
}
