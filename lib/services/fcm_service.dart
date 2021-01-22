import 'dart:convert';
import 'dart:io';
import 'package:chkm8_app/bloc/schedule_mutual/schedule_mutual_bloc.dart';
import 'package:chkm8_app/bloc/schedule_mutual/schedule_mutual_state.dart';
import 'package:chkm8_app/bloc/shared_safety/shared_safety_bloc.dart';
import 'package:chkm8_app/bloc/shared_safety/shared_safety_state.dart';
import 'package:chkm8_app/data/middleware/authentication_middleware.dart';
import 'package:chkm8_app/data/network_response_state.dart';
import 'package:chkm8_app/models/fcm_notification_object.dart';
import 'package:chkm8_app/models/history_rating_object.dart';
import 'package:chkm8_app/models/rating_review_object.dart';
import 'package:chkm8_app/models/schedule_mutual_object.dart';
import 'package:chkm8_app/screens/rate_your_date/start_rating_intro_screen.dart';
import 'package:chkm8_app/screens/schedule_mutual_rating/schedule_pick_date_rating_screen.dart';
import 'package:chkm8_app/screens/share_safety_rating/create_invitation/invitation_code_success_screen.dart';
import 'package:chkm8_app/services/navigation_service.dart';
import 'package:chkm8_app/services/notification_service.dart';
import 'package:chkm8_app/utils/utils.dart';
import 'package:chkm8_app/widgets/message_notification_widget.dart';
import 'package:chkm8_app/wireframe.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';

class FCMService {
  static final FCMService _shared = FCMService._internal();

  FCMService._internal() {
    _register();
  }

  factory FCMService() {
    return _shared;
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  var isBusy = false;

  void _register() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        appPrint("onMessage: $message");
        this.isBusy = true;
        _handleFCMNotification(
          message,
          onForeground: true,
        );
        this.isBusy = false;
      },
      onLaunch: (Map<String, dynamic> message) async {
        appPrint("onLaunch: $message");
        this.isBusy = true;
        Future.delayed(Duration(seconds: 1), () {
          _handleFCMNotification(message);
          this.isBusy = false;
        });
      },
      onResume: (Map<String, dynamic> message) async {
        appPrint("onResume: $message");
        this.isBusy = true;
        Future.delayed(Duration(seconds: 1), () {
          _handleFCMNotification(message);
          this.isBusy = false;
        });
      },
      onBackgroundMessage:
          Platform.isAndroid ? onBackgroundMessageHandler : null,
    );
  }

  void config() {
    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
        sound: true,
        badge: true,
        alert: true,
        provisional: false,
      ),
    );

    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      appPrint("Settings registered: $settings");
    });
    
    _firebaseMessaging.getToken().then((String token) {
      appPrint("Push messaging token: $token");
      if (token == null) {
        throw Exception('Push messaging token is NULL');
      }

      if (token.isEmpty) {
        throw Exception('Push messaging token is empty');
      }

      _submitNotificationToken(token);
    });
  }

  Future<void> _submitNotificationToken(String fcmToken) async {
    var middleware = AuthMiddleware();
    var deviceInfo = DeviceInfoPlugin();
    String deviceId = '';
    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      deviceId = iosDeviceInfo.identifierForVendor;
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      deviceId = androidDeviceInfo.androidId;
    }

    if (deviceId.isEmpty) {
      throw Exception('Push messaging token is empty');
    }

    bool isSuccess = false;
    int limitRetry = 1;
    while (!isSuccess && limitRetry < 5) {
      var repo = await middleware.submitNotificationToken(
          deviceId: deviceId, fcmToken: fcmToken);
      if (repo is ResponseFailedState) {
        limitRetry += 1;
      } else {
        isSuccess = true;
      }
    }

    if (!isSuccess) {
      throw Exception('Submit push messaging token is FAILED');
    }
  }

  void _handleFCMNotification(Map<String, dynamic> message,
      {bool onForeground = false}) {
    var notiObj = FCMNotificationObject.fromJson(message);
    var crNavigator = GetService().navigatorKey;
    var jsString = notiObj.data as String ?? '';
    var datajs = Map();
    if (jsString.isNotEmpty) {
      datajs = jsonDecode(jsString) as Map;
    }

    switch (notiObj.type) {
      case FCMNotiType.ACCEPT_SAFETY_SUCCESS:
        if (datajs.isEmpty) break;

        var ratingObj = RatingReviewObject.fromJson(datajs);
        crNavigator.currentState.push(
          MaterialPageRoute(
            builder: (ctx) {
              return BlocProvider<SharedSafetyBloc>(
                create: (_) => SharedSafetyBloc(
                  SharedSafetyReviewState(rating: ratingObj),
                ),
                child: InvitationCodeSuccessScreen(),
              );
            },
            settings:
                RouteSettings(name: InvitationCodeSuccessScreen.routeName),
          ),
        );
        break;
      case FCMNotiType.ACCEPT_SCHEDULING_RATING:
        if (datajs.isEmpty) break;

        var scheduleObj = ScheduleMutualObject.fromJson(datajs);
        crNavigator.currentState.push(
          MaterialPageRoute(
            builder: (_) => BlocProvider<ScheduleMutualBloc>(
              create: (_) => ScheduleMutualBloc(
                ScheduleMutualInitializeState(
                  scheduleObj: scheduleObj,
                ),
              ),
              child: SchedulePickDateRatingScreen(),
            ),
            settings: RouteSettings(
              name: SchedulePickDateRatingScreen.routeName,
            ),
          ),
        );
        break;
      case FCMNotiType.RATE_DATING:
        if (datajs.isEmpty) break;

        NotificationService().add(NotificationName.NEW_NOTIFICATION);
        void _gotoRating() {
          var ratingObj = HistoryRatingObject.fromJson(datajs);
          crNavigator.currentState.pushNamed(
            StartRatingIntroScreen.routeName,
            arguments: ratingObj,
          );
        }

        if (onForeground) {
          showOverlayNotification(
            (ctx) => MessageNotification(
              message: notiObj.body,
              onTap: () {
                OverlaySupportEntry.of(ctx).dismiss();
                _gotoRating();
              },
            ),
            duration: Duration(seconds: 3),
          );
        } else {
          _gotoRating();
        }
        break;
      case FCMNotiType.KICK_OUT:
        AppWireFrame.logout();
        break;
      default:
        break;
    }

    this.isBusy = false;
  }

  void deleteInstanceID() {
    _firebaseMessaging.deleteInstanceID();
  }

  static Future<dynamic> onBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    appPrint("onBackgroundMessage: $message");
  }
}
