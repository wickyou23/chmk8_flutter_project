import 'package:uuid/uuid.dart';

class RatingQuestionObject {
  final String id = Uuid().v4();
  final String question;
  final List<String> answersOptional;
  Set<String> _userAnswer = Set<String>();
  String otherUserAnswer = '';

  RatingQuestionObject({
    this.question,
    this.answersOptional,
  });

  void addUserAnswer(String answer) {
    if (_userAnswer.contains(answer)) {
      _userAnswer.remove(answer);
      if (answer == 'Other') {
        this.otherUserAnswer = '';
      }
    } else {
      _userAnswer.add(answer);
    }
  }

  void removeUserAnswer(String answer) {
    if (!_userAnswer.contains(answer)) {
      return;
    }

    _userAnswer.remove(answer);
  }

  bool isSelected(String answer) {
    return _userAnswer.contains(answer);
  }

  bool isSelectedOther() {
    return _userAnswer.contains('Other');
  }

  bool isEnableSubmitRating() {
    if (this.isSelectedOther()) {
      return this.otherUserAnswer.isNotEmpty;
    } else {
      return _userAnswer.isNotEmpty;
    }
  }

  void cleanUserAnser() {
    _userAnswer = Set<String>();
    otherUserAnswer = '';
  }

  List<Map<String, dynamic>> getAllAnswer() {
    List<Map<String, dynamic>> rs = List<Map<String, dynamic>>();
    for (var item in _userAnswer) {
      if (item == 'Other') {
        rs.add({
          'id': '',
          'ordinal': 0,
          'answer': this.otherUserAnswer,
        });
      } else {
        rs.add({
          'id': '',
          'ordinal': 0,
          'answer': item,
        });
      }
    }

    return rs;
  }
}
