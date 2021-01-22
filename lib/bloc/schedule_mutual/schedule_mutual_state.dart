import 'package:chkm8_app/data/network_response_state.dart';
import 'package:chkm8_app/models/schedule_mutual_object.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ScheduleMutualState extends Equatable {
  const ScheduleMutualState();

  @override
  List<Object> get props => [];
}

class ScheduleMutualProcessingState extends ScheduleMutualState {}

class ScheduleMutualInitializeState extends ScheduleMutualState {
  final ScheduleMutualObject scheduleObj;

  ScheduleMutualInitializeState({@required this.scheduleObj});

  @override
  List<Object> get props => [scheduleObj];

  @override
  String toString() =>
      'ScheduleMutualInitializeState { scheduleObj: $scheduleObj }';
}

class ScheduleMutualGetSharedCodeSuccessState extends ScheduleMutualState {
  final ScheduleMutualObject scheduleObj;

  ScheduleMutualGetSharedCodeSuccessState({@required this.scheduleObj});

  @override
  List<Object> get props => [scheduleObj];

  @override
  String toString() =>
      'ScheduleMutualGetSharedCodeSuccessState { scheduleObj: $scheduleObj }';
}

class ScheduleMutualGetSharedCodeFailedState extends ScheduleMutualState {
  final ResponseFailedState failedState;

  ScheduleMutualGetSharedCodeFailedState({@required this.failedState});

  @override
  List<Object> get props => [failedState];

  @override
  String toString() =>
      'ScheduleMutualGetSharedCodeFailed { failed: $failedState }';
}

class ScheduleMutualAcceptSharedCodeSuccessState extends ScheduleMutualState {
  final ScheduleMutualObject scheduleObj;

  ScheduleMutualAcceptSharedCodeSuccessState({@required this.scheduleObj});

  @override
  List<Object> get props => [scheduleObj];

  @override
  String toString() =>
      'ScheduleMutualAcceptSharedCodeSuccessState { success: $scheduleObj }';
}

class ScheduleMutualAcceptSharedCodeFailedState extends ScheduleMutualState {
  final ResponseFailedState failedState;

  ScheduleMutualAcceptSharedCodeFailedState({@required this.failedState});

  @override
  List<Object> get props => [failedState];

  @override
  String toString() =>
      'ScheduleMutualAcceptSharedCodeFailedState { failed: $failedState }';
}

class ScheduleMutualValidateSharedCodeSuccessState extends ScheduleMutualState {
}

class ScheduleMutualValidateSharedCodeFailedState extends ScheduleMutualState {
  final ResponseFailedState failedState;

  ScheduleMutualValidateSharedCodeFailedState({@required this.failedState});

  @override
  List<Object> get props => [failedState];

  @override
  String toString() =>
      'ScheduleMutualValidateSharedCodeFailedState { failed: $failedState }';
}

class ScheduleMutualCheckRateSuccessState extends ScheduleMutualState {
  final bool isRated;

  ScheduleMutualCheckRateSuccessState({@required this.isRated});

  @override
  List<Object> get props => [isRated];

  @override
  String toString() =>
      'ScheduleMutualCheckRateSuccessState { isRated: $isRated }';
}

class ScheduleMutualCheckRateFailedState extends ScheduleMutualState {
  final ResponseFailedState failedState;

  ScheduleMutualCheckRateFailedState({@required this.failedState});

  @override
  List<Object> get props => [failedState];

  @override
  String toString() =>
      'ScheduleMutualCheckRateFailedState { failed: $failedState }';
}
