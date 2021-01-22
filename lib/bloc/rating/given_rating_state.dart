import 'package:chkm8_app/data/network_response_state.dart';
import 'package:chkm8_app/models/history_rating_object.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class GivenRatingState extends Equatable {
  const GivenRatingState();

  @override
  List<Object> get props => [];
}

class GivenRatingListInitializeState extends GivenRatingState {}

class GivenRatingListProcessingState extends GivenRatingState {}

class GivenRatingListReadyState extends GivenRatingState {
  final List<HistoryRatingObject> givenList;

  GivenRatingListReadyState({
    this.givenList = const [],
  });

  @override
  String toString() => 'GivenRatingListReadyState { givenList: ${givenList.length} }';
}

class GivenRatingGetListSuccessState extends GivenRatingState {}

class GivenRatingGetListFailedState extends GivenRatingState {
  final ResponseFailedState failedState;

  GivenRatingGetListFailedState({@required this.failedState});

  @override
  String toString() => 'GivenRatingGetListFailedState { failed: $failedState }';
}
