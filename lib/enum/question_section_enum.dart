enum QuestionSectionEnum {
  prospects,
  product,
  personality,
}

extension QuestionSectionEnumExt on QuestionSectionEnum {
  static QuestionSectionEnum initWithRawValue(String rawValue) {
    switch (rawValue) {
      case 'Prospects':
        return QuestionSectionEnum.prospects;
      case 'Product':
        return QuestionSectionEnum.product;
      case 'Personality':
        return QuestionSectionEnum.personality;
      default:
        return null;
    }
  }

  String get rawValue {
    switch (this) {
      case QuestionSectionEnum.prospects:
        return 'Prospects';
      case QuestionSectionEnum.product:
        return 'Product';
      case QuestionSectionEnum.personality:
        return 'Personality';
      default:
        return '';
    }
  }

  String get navTitle {
    switch (this) {
      case QuestionSectionEnum.prospects:
        return 'Prospects';
      case QuestionSectionEnum.product:
        return 'Product';
      case QuestionSectionEnum.personality:
        return 'Personality';
      default:
        return '';
    }
  }

  String get bgNaviImage {
    switch (this) {
      case QuestionSectionEnum.prospects:
        return 'assets/images/bg_navi_prospects_question.png';
      case QuestionSectionEnum.product:
        return 'assets/images/bg_navi_product_question.png';
      case QuestionSectionEnum.personality:
        return 'assets/images/bg_navi_personality_question.png';
      default:
        return '';
    }
  }
}
