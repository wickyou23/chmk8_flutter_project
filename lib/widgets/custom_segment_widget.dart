import 'package:chkm8_app/utils/constant.dart';
import 'package:chkm8_app/utils/extension/color_ext.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';

class CustomSegmentWidget extends StatefulWidget {
  final Function(int) segmentChanged;

  CustomSegmentWidget({@required this.segmentChanged});

  @override
  _CustomSegmentWidgetState createState() => _CustomSegmentWidgetState();
}

class _CustomSegmentWidgetState extends State<CustomSegmentWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;
  Animation<Color> _animationGreyToWhite;
  Animation<Color> _animationWhiteToGrey;
  int _segmentSelected = 0;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _animationController.addListener(() {
      setState(() {});
    });

    _animationGreyToWhite = ColorTween(
      begin: ColorExt.colorWithHex(0x828282),
      end: Colors.white,
    ).animate(_animationController);

    _animationWhiteToGrey = ColorTween(
      begin: Colors.white,
      end: ColorExt.colorWithHex(0x828282),
    ).animate(_animationController);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constrains) {
      if (_animation == null) {
        final Animation curve = CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOut,
        );
        _animation = Tween<double>(
          begin: 4,
          end: (constrains.maxWidth / 2) - 4,
        ).animate(curve);
      }

      return Container(
        height: 54,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(27),
                color: ColorExt.colorWithHex(0xF2F2F2).withPercentAlpha(0.8),
              ),
            ),
            Positioned(
              top: 4,
              left: _animation.value,
              child: Container(
                width: constrains.maxWidth / 2,
                height: 46,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(27),
                    color: Constaint.rateYourDateColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    key: ValueKey(0),
                    child: GestureDetector(
                      onTap: () {
                        _segmentSelected = 0;
                        _animationController.reverse();
                        this.widget.segmentChanged(_segmentSelected);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        child: Text(
                          'Pending Ratings',
                          textAlign: TextAlign.center,
                          style: context.theme.textTheme.headline5.copyWith(
                            fontSize: 18,
                            fontWeight: (_segmentSelected == 0)
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: _animationWhiteToGrey.value,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    key: ValueKey(1),
                    child: GestureDetector(
                      onTap: () {
                        _segmentSelected = 1;
                        _animationController.forward();
                        this.widget.segmentChanged(_segmentSelected);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        child: Text(
                          'Ratings Given',
                          textAlign: TextAlign.center,
                          style: context.theme.textTheme.headline5.copyWith(
                            fontSize: 18,
                            fontWeight: (_segmentSelected == 1)
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: _animationGreyToWhite.value,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
