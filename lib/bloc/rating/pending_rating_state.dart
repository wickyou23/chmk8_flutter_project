import 'package:chkm8_app/data/network_response_state.dart';
import 'package:chkm8_app/models/history_rating_object.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class PendingRatingState extends Equatable {
  const PendingRatingState();

  @override
  List<Object> get props => [];
}

class PendingRatingListInitializeState extends PendingRatingState {}

class PendingRatingListProcessingState extends PendingRatingState {}

class PendingRatingListReadyState extends PendingRatingState {
  final List<HistoryRatingObject> pendingList;

  PendingRatingListReadyState({
    this.pendingList = const [],
  });

  @override
  String toString() =>
      'PendingRatingListReadyState { pendingList: ${pendingList.length} }';
}

class PendingRatingGetListSuccessState extends PendingRatingState {}

class PendingRatingGetListFailedState extends PendingRatingState {
  final ResponseFailedState failedState;

  PendingRatingGetListFailedState({@required this.failedState});

  @override
  String toString() =>
      'PendingRatingGetListFailedState { failed: $failedState }';
}
