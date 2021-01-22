import 'package:equatable/equatable.dart';

abstract class GlobalState extends Equatable {
  const GlobalState();

  @override
  List<Object> get props => [];
}

class GlobalInitializeState extends GlobalState {}

class GlobalProcessingState extends GlobalState {}
