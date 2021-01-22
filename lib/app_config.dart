import 'package:chkm8_app/bloc/simple_bloc_delegate.dart';
import 'package:chkm8_app/services/conectivity_service.dart';
import 'package:chkm8_app/services/local_store_service.dart';
import 'package:chkm8_app/utils/utils.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

enum AppEnvironment { development, production }

class AppConfig {
  static AppEnvironment enviroment;

  static Future<void> appFirstConfig() async {
    // Set `enableInDevMode` to true to see reports while in debug mode
    // This is only to be used for confirming that reports are being
    // submitted as expected. It is not intended to be used for everyday
    // development.
    Crashlytics.instance.enableInDevMode = true;

    // Pass all uncaught errors from the framework to Crashlytics.
    FlutterError.onError = Crashlytics.instance.recordFlutterError;

    WidgetsFlutterBinding.ensureInitialized();
    Utils.blackStatusBar();
    Bloc.observer = MyBlocObserver();

    //Start service
    await LocalStoreService().config();
    ConnectivityService().startService();
  }
}
