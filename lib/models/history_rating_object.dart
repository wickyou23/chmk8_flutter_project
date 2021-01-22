import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:chkm8_app/utils/extension.dart';

class HistoryRatingObject {
  final String id = Uuid().v4();
  final String nickName;
  final double star;
  final String scheduleId;

  String get displayStar {
    return '${this.star.toCSStringAsFixed(1)} ${(this.star > 1) ? 'stars' : 'star'}';
  }

  HistoryRatingObject({
    @required this.scheduleId,
    @required this.nickName,
    this.star = 0,
  });

  factory HistoryRatingObject.fromJson(Map<String, dynamic> map) {
    return HistoryRatingObject(
      nickName: map['nickName'],
      scheduleId: map['scheduleId'],
      star: map['rateSatisfy'],
    );
  }
}
