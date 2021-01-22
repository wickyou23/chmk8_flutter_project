import 'package:flutter/material.dart';
import '../utils/extension.dart';

class DynamicFlexibleSpaceBarTitle extends StatefulWidget {
  final String title;

  DynamicFlexibleSpaceBarTitle({@required this.title});

  @override
  _DynamicFlexibleSpaceBarTitleState createState() =>
      _DynamicFlexibleSpaceBarTitleState();
}

class _DynamicFlexibleSpaceBarTitleState
    extends State<DynamicFlexibleSpaceBarTitle> {
  ScrollPosition _position;
  double _leftPadding = 0;
  double _percent = 0;

  _DynamicFlexibleSpaceBarTitleState();

  @override
  void dispose() {
    _removeScrollableListener();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _removeScrollableListener();
    _addScrollableListener();
    super.didChangeDependencies();
  }

  void _addScrollableListener() {
    _position = Scrollable.of(context)?.position;
    _position?.addListener(_positionListener);
    _positionListener();
  }

  void _positionListener() {
    final FlexibleSpaceBarSettings settings =
        context.dependOnInheritedWidgetOfExactType();
    _getLeftPadding(settings);
  }

  void _removeScrollableListener() =>
      _position?.removeListener(_positionListener);

  void _getLeftPadding(FlexibleSpaceBarSettings settings) {
    final maxSpace = settings.maxExtent - settings.minExtent;
    _percent = (settings.currentExtent - settings.minExtent) / maxSpace;
    final realLeftPadding = 63 - (63 * _percent);
    if (_leftPadding != realLeftPadding) {
      setState(() {
        _leftPadding = realLeftPadding;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final widthText = context.media.size.width - 13;
    return Container(
      width: widthText - (_percent >= 0.88 ? widthText * 0.32 : 30),
      padding: EdgeInsets.only(
        left: 13 + _leftPadding,
        bottom: 14,
      ),
      child: Text(
        widget.title,
        style: context.theme.textTheme.headline6.copyWith(
          color: Colors.white,
        ),
        softWrap: false,
        maxLines: 1,
        overflow: TextOverflow.fade,
      ),
    );
  }
}
