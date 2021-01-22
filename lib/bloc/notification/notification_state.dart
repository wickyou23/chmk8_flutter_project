import 'package:chkm8_app/data/network_response_state.dart';
import 'package:chkm8_app/models/notification_object.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitializeState extends NotificationState {}

class NotificationProcessingState extends NotificationState {}

class NotificationListReadyState extends NotificationState {
  final List<NotificationObject> notiObjs;

  NotificationListReadyState({@required this.notiObjs});

  @override
  String toString() =>
      'NotificationGetNotiListReadyState { notiObjs: ${notiObjs.length} }';
}

class NotificationGetNotiListSuccessState extends NotificationState {}

class NotificationGetNotiListFailedState extends NotificationState {
  final ResponseFailedState failedState;

  NotificationGetNotiListFailedState({@required this.failedState});

  @override
  String toString() =>
      'NotificationGetNotiListFailedState { failed: $failedState }';
}
