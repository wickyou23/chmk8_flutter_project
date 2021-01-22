enum NotificationType {
  rateDating,
  acceptSafetySuccess,
  acceptSchedulingRate,
}

extension NotificationTypeExt on NotificationType {
  static NotificationType initRawValue(String rawValue) {
    switch (rawValue) {
      case 'ACCEPT_SAFETY_SUCCESS':
        return NotificationType.acceptSafetySuccess;
      case 'ACCEPT_SCHEDULING_RATING':
        return NotificationType.acceptSchedulingRate;
      case 'RATE_DATING':
        return NotificationType.rateDating;
      default:
        return null;
    }
  }

  String get rawValue {
    switch (this) {
      case NotificationType.acceptSafetySuccess:
        return 'ACCEPT_SAFETY_SUCCESS';
      case NotificationType.acceptSchedulingRate:
        return 'ACCEPT_SCHEDULING_RATING';
      case NotificationType.rateDating:
        return 'RATE_DATING';
      default:
        return null;
    }
  }
}
