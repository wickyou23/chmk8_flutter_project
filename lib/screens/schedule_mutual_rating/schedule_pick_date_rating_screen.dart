import 'dart:math';

import 'package:chkm8_app/bloc/schedule_mutual/schedule_mutual_bloc.dart';
import 'package:chkm8_app/bloc/schedule_mutual/schedule_mutual_event.dart';
import 'package:chkm8_app/bloc/schedule_mutual/schedule_mutual_state.dart';
import 'package:chkm8_app/models/schedule_mutual_object.dart';
import 'package:chkm8_app/screens/home_screen.dart';
import 'package:chkm8_app/services/local_store_service.dart';
import 'package:chkm8_app/utils/constant.dart';
import 'package:chkm8_app/widgets/app_scaffold.dart';
import 'package:chkm8_app/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SchedulePickDateRatingScreen extends StatefulWidget {
  static final routeName = '/SchedulePickDateRatingScreen';

  @override
  _SchedulePickDateRatingScreenState createState() =>
      _SchedulePickDateRatingScreenState();
}

class _SchedulePickDateRatingScreenState
    extends State<SchedulePickDateRatingScreen> {
  PickDate _pickDate;

  @override
  void initState() {
    LocalStoreService().scheduleCodeWaiting = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AppScaffold(
        body: BlocConsumer<ScheduleMutualBloc, ScheduleMutualState>(
          listener: (ctx, state) {},
          builder: (ctx, state) {
            ScheduleMutualObject scheduleObj;
            if (state is ScheduleMutualInitializeState) {
              scheduleObj = state.scheduleObj;
            }

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(minHeight: context.media.size.height),
                child: IntrinsicHeight(
                  child: Container(
                    padding: EdgeInsets.only(
                      top: context.media.viewPadding.top + 30,
                      left: 20,
                      right: 20,
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          child: Image.asset(
                            'assets/images/bg_schedule_invitation_confirmation.png',
                            fit: BoxFit.cover,
                            width: 192,
                            height: 192 / 1.20798319,
                          ),
                        ),
                        SizedBox(height: 14),
                        Text(
                          'Done and Done!',
                          textAlign: TextAlign.center,
                          style: context.theme.textTheme.headline5.copyWith(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: Constaint.defaultTextColor,
                          ),
                        ),
                        SizedBox(height: 13),
                        Text(
                          'You\'ve set up a Mutual Rating\nfor ${scheduleObj.nickName}.',
                          textAlign: TextAlign.center,
                          style: context.theme.textTheme.headline5.copyWith(
                            fontSize: 16,
                            color: Constaint.defaultTextColor,
                          ),
                        ),
                        SizedBox(height: 13),
                        Text(
                          'Pick a time to receive a reminder to\nrate this date',
                          textAlign: TextAlign.center,
                          style: context.theme.textTheme.headline5.copyWith(
                            fontSize: 16,
                            color: Constaint.defaultTextColor,
                          ),
                        ),
                        SizedBox(height: 30),
                        ..._buildPickDateButton(scheduleObj),
                        SizedBox(height: 30),
                        Expanded(child: Container()),
                        CustomButtonWidget(
                          title: 'Confirm',
                          btnColor: Constaint.scheduleRatingColor,
                          onPressed: _pickDate == null
                              ? null
                              : () {
                                  context.bloc<ScheduleMutualBloc>().add(
                                        ScheduleMutualSetRemindRatingEvent(
                                          id: scheduleObj.id,
                                          time: _pickDate.time,
                                        ),
                                      );
                                  context.navigator.popUntil((route) {
                                    return route.settings.name ==
                                        HomeScreen.routeName;
                                  });
                                },
                        ),
                        SizedBox(
                          height: max(
                            context.media.viewPadding.bottom,
                            30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildPickDateButton(ScheduleMutualObject scheduleObj) {
    List<Widget> widgets = [];
    var pickDateOptionals = scheduleObj.getPickDate();
    for (var item in pickDateOptionals) {
      bool isSelected = _pickDate?.date == item.date;
      widgets.add(
        ClipRRect(
          key: ValueKey(item.date.millisecondsSinceEpoch),
          borderRadius: BorderRadius.circular(10),
          child: FlatButton(
            onPressed: () {
              _pickDate = item;
              setState(() {});
            },
            padding: EdgeInsets.zero,
            highlightColor: Constaint.scheduleRatingColor.withPercentAlpha(0.2),
            splashColor: Constaint.scheduleRatingColor.withPercentAlpha(0.3),
            child: Container(
              height: 55,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected
                      ? Constaint.scheduleRatingColor
                      : ColorExt.colorWithHex(0xBDBDBD),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: <Widget>[
                  Text(
                    item.name,
                    textAlign: TextAlign.center,
                    style: context.theme.textTheme.headline5.copyWith(
                      fontSize: 16,
                      color: isSelected
                          ? Constaint.scheduleRatingColor
                          : Constaint.defaultTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(child: Container()),
                  Text(
                    item.date.csToString('LLL dd, hh:mm a'),
                    textAlign: TextAlign.center,
                    style: context.theme.textTheme.headline5.copyWith(
                      fontSize: 16,
                      color: isSelected
                          ? Constaint.scheduleRatingColor
                          : Constaint.defaultTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      widgets.add(SizedBox(height: 16));
    }

    return widgets;
  }
}
