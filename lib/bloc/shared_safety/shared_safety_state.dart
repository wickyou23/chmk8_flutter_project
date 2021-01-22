import 'package:chkm8_app/data/network_response_state.dart';
import 'package:chkm8_app/models/rating_review_object.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class SharedSafetyState extends Equatable {
  const SharedSafetyState();

  @override
  List<Object> get props => [];
}

class SharedSafetyInitializeState extends SharedSafetyState {}

class SharedSafetyProcessingState extends SharedSafetyState {}

class SharedSafetyGetMyCodeSuccessState extends SharedSafetyState {
  final String sharedSafetyCode;

  SharedSafetyGetMyCodeSuccessState({@required this.sharedSafetyCode});

  @override
  List<Object> get props => [];

  @override
  String toString() =>
      'SharedSafetyGetMyCodeSuccessState { sharedSafetyCode: $sharedSafetyCode }';
}

class SharedSafetyGetMyCodeFailedState extends SharedSafetyState {
  final ResponseFailedState failedState;

  SharedSafetyGetMyCodeFailedState({@required this.failedState});

  @override
  List<Object> get props => [failedState];

  @override
  String toString() =>
      'SharedSafetyGetMyCodeFailedState { failed: $failedState }';
}

class SharedSafetyAcceptCodeSuccessState extends SharedSafetyState {
  final RatingReviewObject rating;

  SharedSafetyAcceptCodeSuccessState({@required this.rating});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'SharedSafetyAcceptCodeSuccessState { star: $rating }';
}

class SharedSafetyAcceptCodeFailedState extends SharedSafetyState {
  final ResponseFailedState failedState;

  SharedSafetyAcceptCodeFailedState({@required this.failedState});

  @override
  List<Object> get props => [failedState];

  @override
  String toString() =>
      'SharedSafetyAcceptCodeFailedState { failed: $failedState }';
}

class SharedSafetyReviewState extends SharedSafetyState {
  final RatingReviewObject rating;

  SharedSafetyReviewState({
    @required this.rating,
  });

  @override
  List<Object> get props => [];

  @override
  String toString() => 'SharedSafetyReviewState { rating: $rating }';
}

class SharedSafetyValidateCodeSuccessState extends SharedSafetyState {}

class SharedSafetyValidateCodeFailedState extends SharedSafetyState {
  final ResponseFailedState failedState;

  SharedSafetyValidateCodeFailedState({@required this.failedState});

  @override
  List<Object> get props => [failedState];

  @override
  String toString() =>
      'SharedSafetyValidateCodeFailedState { failed: $failedState }';
}
