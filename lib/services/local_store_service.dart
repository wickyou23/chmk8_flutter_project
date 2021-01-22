import 'dart:convert';

import 'package:chkm8_app/models/auth_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _LCSKey {
  static const String SKIP_INTRODUCE = 'skipIntroduce';
  static const String CURRENT_USER = 'currentUser';
  // static const String IS_WAITING_ACCPET_SHARED_CODE =
  //     'isWaitingAcceptSharedCode';
  // static const String IS_WAITING_ACCPET_SCHEDULE_CODE =
  //     'isWaitingAcceptScheduleCode';
  static const String SCHEDULE_CODE_WAITING = 'scheduleCodeWaiting';
  static const String SAFETY_CODE_WAITING = 'safetyCodeWaiting';
}

class LocalStoreService {
  static final LocalStoreService _shared = LocalStoreService._internal();

  SharedPreferences _sharedPrefer;

  LocalStoreService._internal();

  factory LocalStoreService() {
    return _shared;
  }

  Future<void> config() async {
    _sharedPrefer = await SharedPreferences.getInstance();
  }

  set isSkipIntroduce(bool skipIntroduce) {
    if (skipIntroduce == null) {
      _sharedPrefer.remove(_LCSKey.SKIP_INTRODUCE);
    } else {
      _sharedPrefer.setBool(_LCSKey.SKIP_INTRODUCE, skipIntroduce);
    }
  }

  bool get isSkipIntroduce {
    return _sharedPrefer.getBool(_LCSKey.SKIP_INTRODUCE) ?? false;
  }

  set setCurrentUser(AuthUser user) {
    String js = jsonEncode(user);
    if (js.isNotEmpty) {
      _sharedPrefer.setString(_LCSKey.CURRENT_USER, js);
    }
  }

  AuthUser get currentUser {
    String js = _sharedPrefer.getString(_LCSKey.CURRENT_USER) ?? '';
    if (js.isEmpty) return null;

    Map jsMap = jsonDecode(js) ?? Map();
    if (jsMap.isEmpty) return null;

    return AuthUser.fromJson(value: jsMap);
  }

  //isWaitingAcceptSharedCode

  // set isWaitingAcceptSharedCode(bool newIsWaitingAcceptSharedCode) {
  //   if (newIsWaitingAcceptSharedCode == null) {
  //     _sharedPrefer.remove(_LCSKey.IS_WAITING_ACCPET_SHARED_CODE);
  //   } else {
  //     _sharedPrefer.setBool(
  //         _LCSKey.IS_WAITING_ACCPET_SHARED_CODE, newIsWaitingAcceptSharedCode);
  //   }
  // }

  bool get isWaitingAcceptSharedCode {
    // return _sharedPrefer.getBool(_LCSKey.IS_WAITING_ACCPET_SHARED_CODE) ??
    //     false;
    return this.safetyCodeWaiting.isNotEmpty;
  }

  //isWaitingAcceptScheduleCode

  // set isWaitingAcceptScheduleCode(bool newIsWaitingAcceptScheduleCode) {
  //   if (newIsWaitingAcceptScheduleCode == null) {
  //     _sharedPrefer.remove(_LCSKey.IS_WAITING_ACCPET_SCHEDULE_CODE);
  //   } else {
  //     _sharedPrefer.setBool(_LCSKey.IS_WAITING_ACCPET_SCHEDULE_CODE,
  //         newIsWaitingAcceptScheduleCode);
  //   }
  // }

  bool get isWaitingAcceptScheduleCode {
    // return _sharedPrefer.getBool(_LCSKey.IS_WAITING_ACCPET_SCHEDULE_CODE) ??
    //     false;
    return this.scheduleCodeWaiting.isNotEmpty;
  }

  //scheduleCodeWaiting

  set scheduleCodeWaiting(String newScheduleCodeWaiting) {
    if (newScheduleCodeWaiting == null || newScheduleCodeWaiting.isEmpty) {
      _sharedPrefer.remove(_LCSKey.SCHEDULE_CODE_WAITING);
    } else {
      _sharedPrefer.setString(
          _LCSKey.SCHEDULE_CODE_WAITING, newScheduleCodeWaiting);
    }
  }

  String get scheduleCodeWaiting {
    return _sharedPrefer.getString(_LCSKey.SCHEDULE_CODE_WAITING) ?? '';
  }

  //safetyCodeWaiting

  set safetyCodeWaiting(String newSafetyCodeWaiting) {
    if (newSafetyCodeWaiting == null || newSafetyCodeWaiting.isEmpty) {
      _sharedPrefer.remove(_LCSKey.SAFETY_CODE_WAITING);
    } else {
      _sharedPrefer.setString(
          _LCSKey.SAFETY_CODE_WAITING, newSafetyCodeWaiting);
    }
  }

  String get safetyCodeWaiting {
    return _sharedPrefer.getString(_LCSKey.SAFETY_CODE_WAITING) ?? '';
  }

  void removeAllCache() {
    _sharedPrefer.clear();
  }

  void logout() {
    // _sharedPrefer.remove(_LCSKey.IS_WAITING_ACCPET_SHARED_CODE);
    // _sharedPrefer.remove(_LCSKey.IS_WAITING_ACCPET_SCHEDULE_CODE);
    _sharedPrefer.remove(_LCSKey.SCHEDULE_CODE_WAITING);
    _sharedPrefer.remove(_LCSKey.SAFETY_CODE_WAITING);
    _sharedPrefer.remove(_LCSKey.CURRENT_USER);
  }
}
