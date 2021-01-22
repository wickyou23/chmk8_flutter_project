import 'package:chkm8_app/bloc/schedule_mutual/schedule_mutual_bloc.dart';
import 'package:chkm8_app/bloc/schedule_mutual/schedule_mutual_state.dart';
import 'package:chkm8_app/models/schedule_mutual_object.dart';
import 'package:chkm8_app/screens/schedule_mutual_rating/create_invitation/schedule_create_nickname_screen.dart';
import 'package:chkm8_app/screens/schedule_mutual_rating/create_invitation/schedule_mutual_rating_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum SchedulePickerTypeEnum {
  rightNow,
  laterToday,
  tomorrow,
  onALaterDate,
}

extension SchedulePickerTypeEnumExt on SchedulePickerTypeEnum {
  String get title {
    switch (this) {
      case SchedulePickerTypeEnum.rightNow:
        return 'Right now';
      case SchedulePickerTypeEnum.laterToday:
        return 'Later today';
      case SchedulePickerTypeEnum.tomorrow:
        return 'Tomorrow';
      case SchedulePickerTypeEnum.onALaterDate:
        return 'On a later date';
      default:
        return '';
    }
  }

  String get valueKey {
    switch (this) {
      case SchedulePickerTypeEnum.rightNow:
        return 'right_now';
      case SchedulePickerTypeEnum.laterToday:
        return 'later_today';
      case SchedulePickerTypeEnum.tomorrow:
        return 'tomorrow';
      case SchedulePickerTypeEnum.onALaterDate:
        return 'on_a_later_date';
      default:
        return '';
    }
  }

  Route get route {
    switch (this) {
      case SchedulePickerTypeEnum.onALaterDate:
        return MaterialPageRoute(
          builder: (_) => ScheduleMutualRatingScreen(),
          settings: RouteSettings(name: ScheduleMutualRatingScreen.routeName),
        );
      default:
        return MaterialPageRoute(
          builder: (_) {
            return BlocProvider<ScheduleMutualBloc>(
              create: (_) => ScheduleMutualBloc(
                ScheduleMutualInitializeState(
                  scheduleObj: ScheduleMutualObject(type: this, pickDate: DateTime.now()),
                ),
              ),
              child: ScheduleCreateNicknameScreen(),
            );
          },
          settings: RouteSettings(name: ScheduleCreateNicknameScreen.routeName),
        );
    }
  }
}
