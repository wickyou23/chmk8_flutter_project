enum LastestAcceptEnum { shareRating, schedulingRating }

extension LastestAcceptEnumExt on LastestAcceptEnum {
  static LastestAcceptEnum initRawValue(String rawValue) {
    switch (rawValue) {
      case 'SHARE_RATING':
        return LastestAcceptEnum.shareRating;
      case 'SCHEDULING_RATING':
        return LastestAcceptEnum.schedulingRating;
      default:
        return null;
    }
  }
}
