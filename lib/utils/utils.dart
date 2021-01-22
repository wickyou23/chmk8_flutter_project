import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chkm8_app/utils/extension.dart';
import 'package:flutter/services.dart' show rootBundle;

void appPrint(Object object) {
  debugPrint(
      '[${DateTime.now().csToString("yyyy:MM:dd hh:mm:ss.SSS")}] $object');
}

class Utils {
  static blackStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarBrightness:
            Platform.isIOS ? Brightness.light : Brightness.dark,
        statusBarIconBrightness:
            Platform.isIOS ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: Colors.green,
      ),
    );
  }

  static whiteStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Platform.isIOS ? Colors.white : Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.green,
      ),
    );
  }

  static TextTheme getCustomTextTheme() {
    return ThemeData.light().textTheme.copyWith(
          headline1: TextStyle(
            fontFamily: 'Muli',
            fontWeight: FontWeight.w300,
            fontSize: 96,
          ),
          headline2: TextStyle(
            fontFamily: 'Muli',
            fontWeight: FontWeight.w300,
            fontSize: 60,
          ),
          headline3: TextStyle(
            fontFamily: 'Muli',
            fontWeight: FontWeight.normal,
            fontSize: 48,
          ),
          headline4: TextStyle(
            fontFamily: 'Muli',
            fontWeight: FontWeight.normal,
            fontSize: 34,
          ),
          headline5: TextStyle(
            fontFamily: 'Muli',
            fontWeight: FontWeight.normal,
            fontSize: 20,
          ),
          headline6: TextStyle(
            fontFamily: 'Muli',
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
          subtitle1: TextStyle(
            fontFamily: 'Muli',
            fontWeight: FontWeight.normal,
            fontSize: 16,
          ),
          subtitle2: TextStyle(
            fontFamily: 'Muli',
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
          button: TextStyle(
            fontFamily: 'Muli',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        );
  }

  static TextTheme getCustomAppBarTextTheme() {
    return Utils.getCustomTextTheme();
  }

  static Widget getLoadingWidget() {
    return Container(
      width: 45,
      height: 45,
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        strokeWidth: 3.0,
      ),
    );
  }

  static Future<String> getMyDialCodeByIp() async {
    Uri uri = Uri.http('www.geoplugin.net', '/json.gp');
    var repo = await Dio().getUri<String>(uri);
    Map jsDeco = jsonDecode(repo.data);
    String countryCode = jsDeco['geoplugin_countryCode'];
    if (countryCode.isEmpty) return '';

    var jsCountry =
        await rootBundle.loadString('assets/resource/country_codes.json');
    List<dynamic> jsCountryDeco = jsonDecode(jsCountry);
    var countryMap = jsCountryDeco.firstWhere((element) {
      if (element is Map && element['code'] == countryCode) {
        return true;
      }

      return false;
    }) as Map;

    if (countryMap != null) {
      return countryMap['dial_code'] ?? '';
    } else {
      return '';
    }
  }
}
