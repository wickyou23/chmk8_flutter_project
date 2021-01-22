import 'package:chkm8_app/models/schedule_mutual_object.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ScheduleMutualEvent extends Equatable {
  const ScheduleMutualEvent();

  @override
  List<Object> get props => [];
}

class ScheduleMutualUpdateDataEvent extends ScheduleMutualEvent {
  final ScheduleMutualObject newScheduleObj;

  ScheduleMutualUpdateDataEvent({@required this.newScheduleObj});

  @override
  List<Object> get props => [newScheduleObj];
}

class ScheduleMutualGetSharedCodeEvent extends ScheduleMutualEvent {
  final ScheduleMutualObject scheduleObj;

  ScheduleMutualGetSharedCodeEvent({
    @required this.scheduleObj,
  });

  @override
  List<Object> get props => [this.scheduleObj];
}

class ScheduleMutualCancelSharedCodeEvent extends ScheduleMutualEvent {
  final String code;

  ScheduleMutualCancelSharedCodeEvent({
    @required this.code,
  });

  @override
  List<Object> get props => [this.code];
}

class ScheduleMutualAcceptSharedCodeEvent extends ScheduleMutualEvent {
  final String code;

  ScheduleMutualAcceptSharedCodeEvent({
    @required this.code,
  });

  @override
  List<Object> get props => [this.code];
}

class ScheduleMutualValidateSharedCodeEvent extends ScheduleMutualEvent {
  final String code;

  ScheduleMutualValidateSharedCodeEvent({
    @required this.code,
  });

  @override
  List<Object> get props => [this.code];
}

class ScheduleMutualSetRemindRatingEvent extends ScheduleMutualEvent {
  final String id;
  final int time;

  ScheduleMutualSetRemindRatingEvent({
    @required this.id,
    @required this.time,
  });

  @override
  List<Object> get props => [this.id, this.time];
}

class ScheduleMutualCheckRatedEvent extends ScheduleMutualEvent {
  final String scheduleId;

  ScheduleMutualCheckRatedEvent({
    @required this.scheduleId,
  });

  @override
  List<Object> get props => [this.scheduleId];
}
