import 'package:chkm8_app/enum/gender_enum.dart';
import 'package:chkm8_app/models/auth_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthReadyEvent extends AuthEvent {
  final AuthUser crUser;

  AuthReadyEvent(this.crUser);

  @override
  List<Object> get props => [crUser];
}

class AuthSignupEvent extends AuthEvent {
  final String phone;
  final String countryCode;

  AuthSignupEvent({
    @required this.phone,
    @required this.countryCode,
  });

  @override
  List<Object> get props => [phone, countryCode];
}

class AuthSigninEvent extends AuthEvent {
  final String phone;
  final String countryCode;

  AuthSigninEvent({
    @required this.phone,
    @required this.countryCode,
  });

  @override
  List<Object> get props => [phone, countryCode];
}

class AuthVerifyCodeEvent extends AuthEvent {
  final String phone;
  final String countryCode;
  final String otpCode;

  AuthVerifyCodeEvent({
    @required this.phone,
    @required this.countryCode,
    @required this.otpCode,
  });

  @override
  List<Object> get props => [phone, otpCode];
}

class AuthGetMyRatingEvent extends AuthEvent {}

class AuthUpdateGenderEvent extends AuthEvent {
  final Gender gender;

  AuthUpdateGenderEvent({this.gender});

  @override
  List<Object> get props => [gender];
}
