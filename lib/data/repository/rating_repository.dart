import 'dart:convert';

import 'package:chkm8_app/models/rating_object.dart';
import 'package:chkm8_app/utils/common_key.dart';
import 'package:flutter/cupertino.dart';
import '../../enum/rating_type_enum.dart';

class RatingRepository {
  static final RatingRepository _shared = RatingRepository._internal();

  RatingRepository._internal();

  factory RatingRepository() {
    return _shared;
  }

  Map<RatingType, RatingObject> _savedAnswer = Map<RatingType, RatingObject>();
  String _scheduleId = '';
  String _overallKey = '';
  String _overallReason = '';

  void saveRating(RatingObject obj) {
    _savedAnswer.update(
      obj.type,
      (value) => obj,
      ifAbsent: () => obj,
    );
  }

  String toJson() {
    if (_scheduleId.isEmpty) return '';

    List<Map<String, dynamic>> _mapAnsJs = List<Map<String, dynamic>>();
    if (_overallReason.isNotEmpty && _overallKey == CommonKey.NOT_HAPPEN) {
      Map<String, dynamic> overallAns = {
        'type': CommonKey.NOT_HAPPEN_REASON,
        'rate': 0,
        'answers': [{
          'id': '',
          'ordinal': 0,
          'answer': _overallReason,
        }],
      };
      _mapAnsJs.add(overallAns);
    }

    _savedAnswer.forEach((key, value) {
      Map<String, dynamic> ans = {
        'type': key.key,
        'rate': value.star,
        'answers': value.crQuestion.getAllAnswer(),
      };
      _mapAnsJs.add(ans);
    });

    return jsonEncode({
      'id': _scheduleId,
      'overall': _overallKey,
      'ratings': _mapAnsJs ?? [],
    });
  }

  void addOverall({
    @required String scheduleId,
    @required String overallKey,
    @required String overallReason,
  }) {
    _overallKey = overallKey;
    _overallReason = overallReason;
    _scheduleId = scheduleId;
  }

  void clean() {
    _savedAnswer = Map<RatingType, RatingObject>();
    _overallReason = '';
    _overallKey = '';
    _scheduleId = '';
  }
}
