import 'dart:convert';

import 'package:chkm8_app/enum/lastest_accept_enum.dart';
import 'package:chkm8_app/models/rating_review_object.dart';
import 'package:chkm8_app/models/schedule_mutual_object.dart';

class LastestAcceptObject {
  final String code;
  final LastestAcceptEnum type;
  final dynamic data;
  final int createTime;

  LastestAcceptObject({
    this.code,
    this.type,
    this.data,
    this.createTime,
  });

  factory LastestAcceptObject.fromJson(Map<String, dynamic> js) {
    var nType = LastestAcceptEnumExt.initRawValue(js['type'] ?? '');
    if (nType == null) return null;

    dynamic nData;
    String dataStr = js['data'] ?? '';
    switch (nType) {
      case LastestAcceptEnum.shareRating:
        nData = RatingReviewObject.fromJson(jsonDecode(dataStr));
        break;
      case LastestAcceptEnum.schedulingRating:
        nData = ScheduleMutualObject.fromJson(jsonDecode(dataStr));
        break;
      default:
        break;
    }

    return LastestAcceptObject(
      code: js['code'] ?? '',
      type: nType,
      data: nData,
      createTime: js['createTime'] as int ?? 0,
    );
  }
}
