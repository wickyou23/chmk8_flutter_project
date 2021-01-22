import 'dart:convert';

import 'package:chkm8_app/enum/gender_enum.dart';
import 'package:chkm8_app/models/rating_review_object.dart';
import 'package:flutter/foundation.dart';
import 'package:chkm8_app/utils/extension.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class AuthUser {
  final String phone;
  final String countryCode;
  final String accessToken;
  final String tokenType;
  final String genderString;
  final int expiresIn;
  final int ratingReceived;
  final int ratingGiven;
  final RatingReviewObject safetyRating;
  final RatingReviewObject integrityRating;
  final RatingReviewObject repeatRating;

  Gender get gender {
    return GenderExt.initRawValue(this.genderString);
  }

  AuthUser(
      {this.phone,
      this.countryCode,
      this.accessToken,
      this.expiresIn,
      this.tokenType,
      this.ratingReceived = 0,
      this.ratingGiven = 0,
      this.safetyRating,
      this.integrityRating,
      this.repeatRating,
      this.genderString});

  factory AuthUser.fromJson({@required Map<String, dynamic> value}) {
    RatingReviewObject safetyRating;
    RatingReviewObject integrityRating;
    RatingReviewObject repeatRating;
    dynamic safetyJS = value['safetyRating'];
    dynamic integrityJS = value['integrityRating'];
    dynamic repeatJS = value['repeatRating'];
    if (safetyJS is String && safetyJS.isNotEmpty) {
      var mapJS = jsonDecode(safetyJS) as Map;
      mapJS.update('type', (value) => 1, ifAbsent: () => 1);
      safetyRating = RatingReviewObject.fromJson(mapJS);
    } else if (safetyJS is Map) {
      safetyJS.update('type', (value) => 1, ifAbsent: () => 1);
      safetyRating = RatingReviewObject.fromJson(safetyJS);
    }

    if (integrityJS is String && integrityJS.isNotEmpty) {
      var mapJS = jsonDecode(integrityJS) as Map;
      mapJS.update('type', (value) => 2, ifAbsent: () => 2);
      integrityRating = RatingReviewObject.fromJson(mapJS);
    } else if (integrityJS is Map) {
      integrityJS.update('type', (value) => 2, ifAbsent: () => 2);
      integrityRating = RatingReviewObject.fromJson(integrityJS);
    }

    if (repeatJS is String && repeatJS.isNotEmpty) {
      var mapJS = jsonDecode(repeatJS) as Map;
      mapJS.update('type', (value) => 3, ifAbsent: () => 3);
      repeatRating = RatingReviewObject.fromJson(mapJS);
    } else if (repeatJS is Map) {
      repeatJS.update('type', (value) => 3, ifAbsent: () => 3);
      repeatRating = RatingReviewObject.fromJson(repeatJS);
    }

    return AuthUser(
      phone: value['phone'] ?? '',
      countryCode: value['countryCode'] ?? '',
      accessToken: value['accessToken'],
      tokenType: value['tokenType'],
      expiresIn: value['expiresIn'],
      ratingReceived: value['numReceived'] ?? 0,
      ratingGiven: value['numGiven'] ?? 0,
      safetyRating: safetyRating,
      integrityRating: integrityRating,
      repeatRating: repeatRating,
      genderString: value['gender'],
    );
  }

  Map<String, dynamic> toJson() => {
        'phone': this.phone,
        'countryCode': this.countryCode,
        'accessToken': this.accessToken,
        'expiresIn': this.expiresIn,
        'tokenType': this.tokenType,
        'numReceived': this.ratingReceived,
        'numGiven': this.ratingGiven,
        'safetyRating':
            this.safetyRating == null ? '' : jsonEncode(this.safetyRating),
        'integrityRating': this.integrityRating == null
            ? ''
            : jsonEncode(this.integrityRating),
        'repeatRating':
            this.repeatRating == null ? '' : jsonEncode(this.repeatRating),
        'gender': this.genderString,
      };

  AuthUser copyWith({
    String phone,
    String countryCode,
    String accessToken,
    String tokenType,
    String genderString,
    int expiresIn,
    int ratingReceived,
    int ratingGiven,
    RatingReviewObject safetyRating,
    RatingReviewObject integrityRating,
    RatingReviewObject repeatRating,
  }) {
    return AuthUser(
      phone: phone ?? this.phone,
      countryCode: countryCode ?? this.countryCode,
      accessToken: accessToken ?? this.accessToken,
      tokenType: tokenType ?? this.tokenType,
      genderString: genderString ?? this.genderString,
      expiresIn: expiresIn ?? this.expiresIn,
      ratingReceived: ratingReceived ?? this.ratingReceived,
      ratingGiven: ratingGiven ?? this.ratingGiven,
      safetyRating: safetyRating ?? this.safetyRating,
      integrityRating: integrityRating ?? this.integrityRating,
      repeatRating: repeatRating ?? this.repeatRating,
    );
  }
}

extension AuthUserExt on AuthUser {
  String get verifyCodePhoneDisplay {
    String display = '';
    for (var i = 0; i < this.phone.length - 2; i++) {
      display += '*';
    }

    return display + this.phone.substring(this.phone.length - 2);
  }

  Future<String> getMyProfilePhoneDisplay() async {
    var fmPhone = await PhoneNumber.getRegionInfoFromPhoneNumber(
      this.phone,
    );

    String display = '';
    for (var i = 1;
        i < this.phone.length - (fmPhone.dialCode.length + 2);
        i++) {
      display += '*';
    }

    return '+${fmPhone.dialCode}' +
        display +
        this.phone.substring(this.phone.length - 2);
  }

  String get fullAccessToken {
    return this.tokenType.toCapitalizedCase() + ' ' + this.accessToken;
  }
}
