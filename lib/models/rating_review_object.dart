import 'dart:math';
import 'package:chkm8_app/enum/rating_type_enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:chkm8_app/utils/extension.dart';

class RatingReviewObject {
  final RatingType type;
  final double star;
  final String code;
  final int baseON;
  final int ratingTime;

  RatingReviewObject({
    @required this.star,
    @required this.code,
    @required this.baseON,
    @required this.ratingTime,
    this.type,
  });

  factory RatingReviewObject.fromJson(Map<String, dynamic> json) {
    double cvRate = 0;
    if (json['rate'] is double) {
      cvRate = json['rate'];
    } else if (json['rate'] is int) {
      cvRate = (json['rate'] as int).toDouble();
    }

    RatingType type;
    if (json['type'] is int) {
      type = RatingTypeExt.initWithRawValue(json['type']);
    }

    return RatingReviewObject(
      star: cvRate,
      baseON: json['count'] ?? 0,
      ratingTime: json['time'],
      code: json['code'] ?? '',
      type: type,
    );
  }

  Map<String, dynamic> toJson() => {
        'rate': this.star,
        'count': this.baseON,
        'time': this.ratingTime,
        'code': this.code,
        'type': this.type.rawValue,
      };

  RatingReviewObject copyWith(
      {double star, String code, int baseON, int ratingTime, RatingType type}) {
    return RatingReviewObject(
        star: star ?? this.star,
        code: code ?? this.code,
        baseON: baseON ?? this.baseON,
        ratingTime: ratingTime ?? this.ratingTime,
        type: type ?? this.type);
  }
}

extension RatingReviewObjectExt on RatingReviewObject {
  DateTime get ratingDate {
    return DateTime.fromMillisecondsSinceEpoch(this.ratingTime);
  }

  String get displayStarStatus {
    int idx = 4 - max(min(this.star.round() - 1, 4), 0);
    return this.type.getStarDesc()[idx];
  }

  String get displayRatingDate {
    return 'Issued on ${this.ratingDate.csToString('MM/dd/yyyy')} at ${this.ratingDate.csToString('HH:mm a')}';
  }

  String get displayBaseOn {
    if (this.baseON < 3) {
      return 'Not yet rated';
    }

    return 'Based on ${this.baseON} ratings';
  }
}
