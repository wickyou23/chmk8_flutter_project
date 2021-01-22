import 'package:chkm8_app/enum/schedule_type_enum.dart';
import 'package:chkm8_app/utils/constant.dart';
import 'package:chkm8_app/widgets/app_scaffold.dart';
import 'package:chkm8_app/widgets/custom_button_widget.dart';
import 'package:chkm8_app/widgets/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';

class ScheduleRatingSelectionScreen extends StatefulWidget {
  static final routeName = '/ScheduleRatingSelectionScreen';

  @override
  _ScheduleRatingSelectionScreenState createState() =>
      _ScheduleRatingSelectionScreenState();
}

class _ScheduleRatingSelectionScreenState
    extends State<ScheduleRatingSelectionScreen> {
  final List<SchedulePickerTypeEnum> _selectionType = [
    SchedulePickerTypeEnum.rightNow,
    SchedulePickerTypeEnum.laterToday,
    SchedulePickerTypeEnum.tomorrow,
    SchedulePickerTypeEnum.onALaterDate,
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          CustomNavigationBar(
            navTitle: 'Schedule Mutual Rating',
            navTitleColor: Constaint.scheduleRatingColor,
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(
              top: CustomNavigationBar.heightNavBar +
                  context.media.viewPadding.top,
              left: 20,
              right: 20,
            ),
            child: Column(
              children: <Widget>[
                SizedBox(height: 46),
                Text(
                  'When are you going on this date?',
                  textAlign: TextAlign.center,
                  style: context.theme.textTheme.headline5.copyWith(
                    fontSize: 16,
                    color: Constaint.defaultTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 35),
                ..._generalScheduleButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _generalScheduleButton() {
    List<Widget> widgets = [];
    for (var type in _selectionType) {
      widgets.add(CustomButtonWidget(
        key: ValueKey(type.valueKey),
        title: type.title,
        width: 203,
        height: 56,
        radius: 9,
        type: CustomButtonType.line,
        tintColor: Constaint.scheduleRatingColor,
        onPressed: () {
          context.navigator.push(type.route);
        },
      ));
      widgets.add(SizedBox(height: 20));
    }

    return widgets;
  }
}
