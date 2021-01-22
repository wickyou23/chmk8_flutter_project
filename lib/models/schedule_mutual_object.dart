import 'package:chkm8_app/enum/schedule_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';

class PickDate {
  final String name;
  final DateTime date;
  final int time;

  const PickDate({
    @required this.name,
    @required this.date,
    @required this.time,
  });
}

class ScheduleMutualObject {
  final String id;
  final SchedulePickerTypeEnum type;
  final String nickName;
  final String sharedCode;
  final DateTime pickDate;
  final DateTime ratingDate;
  final PickDate reminderPickDate;
  final List<int> svRatingTime;

  ScheduleMutualObject({
    this.nickName,
    this.type,
    this.pickDate,
    this.ratingDate,
    this.sharedCode,
    this.reminderPickDate,
    this.svRatingTime,
    this.id,
  });

  factory ScheduleMutualObject.fromJson(Map<String, dynamic> map) {
    String scheduleId = map['scheduleId'];
    if (scheduleId == null) {
      scheduleId = map['id'] ?? '';
    }

    int time = map['time'];
    if (time == null) {
      time = map['datingTime'] ?? DateTime.now().millisecondsSinceEpoch;
    }

    return ScheduleMutualObject(
      id: scheduleId,
      nickName: map['nickName'],
      pickDate: DateTime.fromMillisecondsSinceEpoch(time),
      svRatingTime: map['ratingTime'].cast<int>(),
    );
  }

  ScheduleMutualObject copyWith({
    String id,
    SchedulePickerTypeEnum type,
    String nickName,
    String sharedCode,
    DateTime pickDate,
    DateTime ratingDate,
    PickDate reminderPickDate,
    List<int> svRatingTime,
  }) {
    return ScheduleMutualObject(
      id: id ?? this.id,
      nickName: nickName ?? this.nickName,
      type: type ?? this.type,
      sharedCode: sharedCode ?? this.sharedCode,
      pickDate: pickDate ?? this.pickDate,
      ratingDate: ratingDate ?? this.ratingDate,
      reminderPickDate: reminderPickDate ?? this.reminderPickDate,
      svRatingTime: svRatingTime ?? this.svRatingTime,
    );
  }
}

extension ScheduleMututalObjectExt on ScheduleMutualObject {
  List<PickDate> getPickDate() {
    if (this.svRatingTime.isEmpty && this.svRatingTime.length > 3) return [];
    var pickType = this.type;
    if (pickType == null) {
      if (this.pickDate.isToday()) {
        pickType = SchedulePickerTypeEnum.laterToday;
      } else if (!this.pickDate.isTomorrow()) {
        pickType = SchedulePickerTypeEnum.tomorrow;
      } else {
        pickType = SchedulePickerTypeEnum.onALaterDate;
      }
    }

    List<PickDate> pick = [];
    switch (pickType) {
      case SchedulePickerTypeEnum.rightNow:
      case SchedulePickerTypeEnum.laterToday:
        var toNight = DateTime.fromMillisecondsSinceEpoch(this.svRatingTime[0]);
        var nextMorning =
            DateTime.fromMillisecondsSinceEpoch(this.svRatingTime[1]);
        var nextEvening =
            DateTime.fromMillisecondsSinceEpoch(this.svRatingTime[2]);
        if (this.pickDate.millisecondsSinceEpoch <
            toNight.millisecondsSinceEpoch) {
          pick.add(PickDate(
            name: 'Tonight',
            date: toNight,
            time: this.svRatingTime[0],
          ));
        }
        pick.add(PickDate(
          name: 'Tomorrow morning',
          date: nextMorning,
          time: this.svRatingTime[1],
        ));
        pick.add(PickDate(
          name: 'Tomorrow evening',
          date: nextEvening,
          time: this.svRatingTime[2],
        ));
        return pick;
      case SchedulePickerTypeEnum.tomorrow:
        var nextNight =
            DateTime.fromMillisecondsSinceEpoch(this.svRatingTime[0]);
        var nextDateMorning =
            DateTime.fromMillisecondsSinceEpoch(this.svRatingTime[1]);
        var nextDateEvening =
            DateTime.fromMillisecondsSinceEpoch(this.svRatingTime[2]);
        pick.add(PickDate(
          name: 'Tomorrow night',
          date: nextNight,
          time: this.svRatingTime[0],
        ));
        pick.add(PickDate(
          name: '${nextDateMorning.csToString('EEEE')} morning',
          date: nextDateMorning,
          time: this.svRatingTime[1],
        ));
        pick.add(PickDate(
          name: '${nextDateMorning.csToString('EEEE')} evening',
          date: nextDateEvening,
          time: this.svRatingTime[2],
        ));
        return pick;
      case SchedulePickerTypeEnum.onALaterDate:
        var pickDateNight =
            DateTime.fromMillisecondsSinceEpoch(this.svRatingTime[0]);
        var nextPickDateMorning =
            DateTime.fromMillisecondsSinceEpoch(this.svRatingTime[1]);
        var nextPickDateEvening =
            DateTime.fromMillisecondsSinceEpoch(this.svRatingTime[2]);
        pick.add(PickDate(
          name: '${pickDateNight.csToString('EEEE')} night',
          date: pickDateNight,
          time: this.svRatingTime[0],
        ));
        pick.add(PickDate(
          name: '${nextPickDateMorning.csToString('EEEE')} morning',
          date: nextPickDateMorning,
          time: this.svRatingTime[1],
        ));
        pick.add(PickDate(
          name: '${nextPickDateEvening.csToString('EEEE')} evening',
          date: nextPickDateEvening,
          time: this.svRatingTime[2],
        ));
        return pick;
      default:
        return [];
    }
  }
}
