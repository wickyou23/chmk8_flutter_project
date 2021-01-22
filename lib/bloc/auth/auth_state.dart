import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:chkm8_app/data/network_response_state.dart';
import 'package:chkm8_app/models/auth_user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitializeState extends AuthState {}

class AuthReadyState extends AuthState {
  final AuthUser crUser;

  AuthReadyState(this.crUser);

  @override
  List<Object> get props => [crUser];

  @override
  String toString() => 'AuthReadyState { crUser: $crUser }';
}

class AuthProcessingState extends AuthState {}

// SIGNUP state

class AuthSignupSuccessState extends AuthState {
  final AuthUser crUser;

  AuthSignupSuccessState(this.crUser);

  @override
  List<Object> get props => [crUser];

  @override
  String toString() => 'AuthReadyState { crUser: $crUser }';
}

class AuthSignupFailedState extends AuthState {
  final ResponseFailedState failedState;

  AuthSignupFailedState({@required this.failedState});

  @override
  List<Object> get props => [failedState];

  @override
  String toString() => 'AuthSignupFailedState { failed: $failedState }';
}

// SIGNIN state

class AuthSigninSuccessState extends AuthState {
  final AuthUser crUser;

  AuthSigninSuccessState(this.crUser);

  @override
  List<Object> get props => [crUser];

  @override
  String toString() => 'AuthReadyState { crUser: $crUser }';
}

class AuthSigninFailedState extends AuthState {
  final ResponseFailedState failedState;

  AuthSigninFailedState({@required this.failedState});

  @override
  List<Object> get props => [failedState];

  @override
  String toString() => 'AuthSigninFailedState { failed: $failedState }';
}

// VERIFYCODE state

class AuthVerifyCodeFailedState extends AuthState {
  final ResponseFailedState failedState;

  AuthVerifyCodeFailedState({@required this.failedState});

  @override
  List<Object> get props => [failedState];

  @override
  String toString() => 'AuthVerifyCodeFailedState { failed: $failedState }';
}

// UPDATE GENDER state

class AuthUpdateGenderSuccessState extends AuthState {}

class AuthUpdateGenderFailedState extends AuthState {
  final ResponseFailedState failedState;

  AuthUpdateGenderFailedState({@required this.failedState});

  @override
  List<Object> get props => [failedState];

  @override
  String toString() => 'AuthUpdateGenderFailedState { failed: $failedState }';
}
