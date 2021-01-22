import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class SharedSafetyEvent extends Equatable {
  const SharedSafetyEvent();

  @override
  List<Object> get props => [];
}

class SharedSafetyGetMyCodeEvent extends SharedSafetyEvent {}

class SharedSafetyAcceptCodeEvent extends SharedSafetyEvent {
  final String code;

  SharedSafetyAcceptCodeEvent({@required this.code});

  @override
  List<Object> get props => [code];
}

class SharedSafetyValidateCodeEvent extends SharedSafetyEvent {
  final String code;

  SharedSafetyValidateCodeEvent({@required this.code});

  @override
  List<Object> get props => [code];
}


class SharedSafetCancelInvitationCodeEvent extends SharedSafetyEvent {
  final String code;

  SharedSafetCancelInvitationCodeEvent({@required this.code});

  @override
  List<Object> get props => [code];
}