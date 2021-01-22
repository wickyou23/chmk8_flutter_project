import 'dart:async';
import 'package:chkm8_app/app_config.dart';
import 'package:chkm8_app/app_entry.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

Future<Null> main() async {
  AppConfig.enviroment = AppEnvironment.development;
  await AppConfig.appFirstConfig();

  runZoned(() {
    runApp(MyApp());
  }, onError: Crashlytics.instance.recordError);
}