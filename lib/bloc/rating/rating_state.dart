import 'package:chkm8_app/data/network_response_state.dart';
import 'package:chkm8_app/models/history_rating_object.dart';
import 'package:chkm8_app/models/rating_object.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class RatingState extends Equatable {
  const RatingState();

  @override
  List<Object> get props => [];
}

//RATING PROCESS

class RatingProcessingState extends RatingState {}

class RatingReadyState extends RatingState {
  final RatingObject crRating;

  RatingReadyState({@required this.crRating});

  @override
  List<Object> get props => [crRating];

  @override
  String toString() => 'RatingReadyState { crRating: $crRating }';
}

class OverallRatingReadyState extends RatingState {
  final HistoryRatingObject historyRating;

  OverallRatingReadyState({@required this.historyRating});

  @override
  List<Object> get props => [historyRating];

  @override
  String toString() => 'OverallRatingReadyState { historyRating: $historyRating }';
}

class RatingCompletionSuccessState extends RatingState {}

class RatingCompletionFailedState extends RatingState {
  final ResponseFailedState failedState;

  RatingCompletionFailedState({@required this.failedState});

  @override
  String toString() => 'RatingCompletionFailedState { failed: $failedState }';
}

class OverallRatingCompletionState extends RatingState {}
