import 'package:flutter/cupertino.dart';

enum HomeTab { dashboard, profile, notification, faq }

extension HomeTabExt on HomeTab {
  static HomeTab initRawValue(int rawValue) {
    switch (rawValue) {
      case 0:
        return HomeTab.dashboard;
      case 1:
        return HomeTab.profile;
      case 2:
        return HomeTab.notification;
      case 3:
        return HomeTab.faq;
      default:
        return null;
    }
  }

  int get rawValue {
    switch (this) {
      case HomeTab.dashboard:
        return 0;
      case HomeTab.profile:
        return 1;
      case HomeTab.notification:
        return 2;
      case HomeTab.faq:
        return 3;
      default:
        return null;
    }
  }

  Key get keyValue {
    switch (this) {
      case HomeTab.dashboard:
        return ValueKey('dashboard');
      case HomeTab.profile:
        return ValueKey('profile');
      case HomeTab.notification:
        return ValueKey('notification');
      case HomeTab.faq:
        return ValueKey('faq');
      default:
        return null;
    }
  }
}
