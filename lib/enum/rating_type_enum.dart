import 'package:chkm8_app/models/rating_question_object.dart';

enum RatingType { safety, integrity, repeat }

extension RatingTypeExt on RatingType {
  static RatingType initWithRawValue(int value) {
    switch (value) {
      case 1:
        return RatingType.safety;
      case 2:
        return RatingType.integrity;
      case 3:
        return RatingType.repeat;
      default:
        return null;
    }
  }

  int get rawValue {
    switch (this) {
      case RatingType.safety:
        return 1;
      case RatingType.integrity:
        return 2;
      case RatingType.repeat:
        return 3;
      default:
        return null;
    }
  }

  String get key {
    switch (this) {
      case RatingType.safety:
        return 'SAFETY_RATING';
      case RatingType.integrity:
        return 'INTEGRITY_RATING';
      case RatingType.repeat:
        return 'REPEAT_RATING';
      default:
        return null;
    }
  }

  String getDesc() {
    switch (this) {
      case RatingType.safety:
        return 'How safe did you feel on this date?';
      case RatingType.integrity:
        return 'Did your date live up to their photos and the info they shared?';
      case RatingType.repeat:
        return 'Would you be interested in a repeat date with this person?';
      default:
        return '';
    }
  }

  String getTitle() {
    switch (this) {
      case RatingType.safety:
        return 'Safety Rating';
      case RatingType.integrity:
        return 'Integrity Rating';
      case RatingType.repeat:
        return 'Repeat Rating';
      default:
        return '';
    }
  }

  String getMyTitle() {
    switch (this) {
      case RatingType.safety:
        return 'My Safety Rating';
      case RatingType.integrity:
        return 'My Integrity Rating';
      case RatingType.repeat:
        return 'My Repeat Rating';
      default:
        return '';
    }
  }

  RatingQuestionObject getQuestion() {
    switch (this) {
      case RatingType.safety:
        return RatingQuestionObject(
          question: 'Why didn\'t you feel safe?',
          answersOptional: [
            'Unsafe driving during the date',
            'Language used caused me stress/anxiety/fear',
            'Aggressive behavior not anticipated',
            'Physically abusive',
            'Location selected or ambiance caused me stress/anxiety/fear',
            'Other',
          ],
        );
      case RatingType.integrity:
        return RatingQuestionObject(
          question: 'Why did your date not match your expectation?',
          answersOptional: [
            'Pics shared prior to date were not current photos or not the actual user\'s photos',
            'Agreed-upon arrangements were not met or were changed without my understanding',
            'Stats provided by the user were grossly inaccurate and would have affected my decision to connect',
            'Other',
          ],
        );
      case RatingType.repeat:
        return RatingQuestionObject(
          question:
              'Why would you likely not go on a repeat date with this person?',
          answersOptional: [
            'Our date was totally different then what I thought it would be',
            'The place we met/went was not acceptable',
            'User did not care about their appearance',
            'User embarrassed me in front of others',
            'Awkward meeting; lacking chemistry',
            'Other',
          ],
        );
      default:
        return null;
    }
  }

  RatingType getNextType() {
    switch (this) {
      case RatingType.safety:
        return RatingType.integrity;
      case RatingType.integrity:
        return RatingType.repeat;
      default:
        return null;
    }
  }

  String getStepImage() {
    switch (this) {
      case RatingType.safety:
        return 'assets/images/bg_rating_step_one.png';
      case RatingType.integrity:
        return 'assets/images/bg_rating_step_two.png';
      case RatingType.repeat:
        return 'assets/images/bg_rating_step_three.png';
      default:
        return '';
    }
  }

  List<String> getStarDesc() {
    switch (this) {
      case RatingType.safety:
        return [
          'Extremely Safe',
          'Safe',
          'Neutral',
          'Unsafe',
          'Extremely Unsafe',
        ];
      case RatingType.integrity:
        return [
          'Very Accurate',
          'Mostly Accurate',
          'Neutral',
          'Mostly Inaccurate',
          'Very Inaccurate',
        ];
      case RatingType.repeat:
        return [
          'Definitely',
          'Probably',
          'Neutral',
          'Probably Not',
          'Definitely Not',
        ];
      default:
        return [];
    }
  }

  String getFAQTitle() {
    switch (this) {
      case RatingType.safety:
        return 'What is Safety Rating?';
      case RatingType.integrity:
        return 'What is Integrity?';
      case RatingType.repeat:
        return 'What is Repeat Date Rating?';
      default:
        return '';
    }
  }

  String getRatingFAQAns() {
    switch (this) {
      case RatingType.safety:
        return 'A Safety Rating shows how safe a person is to meet and hang-out with based on the past Safety Ratings he/she has received.';
      case RatingType.integrity:
        return 'An Integrity Rating shows how much this person’s previous dates think he/she match with his/her online profile and portrayal.';
      case RatingType.repeat:
        return 'A Repeat Date shows how willing this person’s previous dates to date him/her again.';
      default:
        return '';
    }
  }
}