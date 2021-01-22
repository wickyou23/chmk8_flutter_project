import 'package:equatable/equatable.dart';

abstract class PendingRatingEvent extends Equatable {
  const PendingRatingEvent();

  @override
  List<Object> get props => [];
}

class PendingRatingGetListEvent extends PendingRatingEvent {}
