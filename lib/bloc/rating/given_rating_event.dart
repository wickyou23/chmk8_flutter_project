import 'package:equatable/equatable.dart';

abstract class GivenRatingEvent extends Equatable {
  const GivenRatingEvent();

  @override
  List<Object> get props => [];
}

class GivenRatingGetListEvent extends GivenRatingEvent {}
