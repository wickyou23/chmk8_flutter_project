import 'package:chkm8_app/models/rating_object.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class RatingEvent extends Equatable {
  const RatingEvent();

  @override
  List<Object> get props => [];
}

class RatingSavedEvent extends RatingEvent {
  final RatingObject ratingObj;

  RatingSavedEvent({@required this.ratingObj});

  @override
  List<Object> get props => [ratingObj];
}

class RatingCompletionEvent extends RatingEvent {
  final RatingObject ratingObj;

  RatingCompletionEvent({@required this.ratingObj});

  @override
  List<Object> get props => [ratingObj];
}

class OverrallRatingEvent extends RatingEvent {
  final String scheduleId;
  final String overallKey;
  final String overallReason;

  OverrallRatingEvent({
    @required this.scheduleId,
    @required this.overallKey,
    this.overallReason,
  });

  @override
  List<Object> get props => [scheduleId, overallKey, overallReason];
}
