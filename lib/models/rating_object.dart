import 'package:flutter/material.dart';

import '../enum/rating_type_enum.dart';
import 'rating_question_object.dart';

class RatingObject {
  final RatingType type;
  final String scheduleId;
  final String nickName;

  int star = 0;
  RatingQuestionObject _question;

  RatingObject({
    @required this.type,
    @required this.scheduleId,
    @required this.nickName,
  }) {
    _question = this.type.getQuestion();
  }

  RatingObject copyWith({
    RatingType type,
    String schedule,
    String nickName,
    RatingQuestionObject savedAnswer,
  }) {
    return RatingObject(
      type: type ?? this.type,
      scheduleId: scheduleId ?? this.scheduleId,
      nickName: nickName ?? this.nickName,
    );
  }

  RatingQuestionObject get crQuestion {
    return _question;
  }

  bool get isCompleted {
    return type == RatingType.repeat;
  }

  void cleanUserAnswer() {
    _question.cleanUserAnser();
  }
}
