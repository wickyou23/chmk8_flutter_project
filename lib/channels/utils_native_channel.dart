import 'dart:convert';
import 'package:flutter/services.dart';

class _UtilsCNFunName {
  static const GET_CITY_TIMEZONE = 'getCityTimeZone';
  static const GET_DEFAULT_PROXY = 'getProxyDefault';
  static const CANCEL_ALL_NOTIFICATION_TRAY = 'cancelAllNotificationTray';
}

class UtilsNativeChannel {
  final nativePlatform = const MethodChannel('flutter.tp.utilsNativeChannel');

  Future<String> getCityTimeZone() async {
    try {
      return await nativePlatform
          .invokeMethod(_UtilsCNFunName.GET_CITY_TIMEZONE);
    } catch (e) {
      return '';
    }
  }

  Future<Map> getProxyDefault() async {
    try {
      var js =
          await nativePlatform.invokeMethod(_UtilsCNFunName.GET_DEFAULT_PROXY);
      return jsonDecode(js) as Map;
    } catch (e) {
      return null;
    }
  }

  Future<void> cancelAllNotificationTray() async {
    try {
      await nativePlatform
          .invokeMethod(_UtilsCNFunName.CANCEL_ALL_NOTIFICATION_TRAY);
    } catch (e) {
      return null;
    }
  }
}
