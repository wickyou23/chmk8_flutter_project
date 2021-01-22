import 'dart:io';

class FCMNotiType {
  static const ACCEPT_SAFETY_SUCCESS = 'ACCEPT_SAFETY_SUCCESS';
  static const ACCEPT_SCHEDULING_RATING = 'ACCEPT_SCHEDULING_RATING';
  static const RATE_DATING = 'RATE_DATING';
  static const KICK_OUT = 'KICK_OUT';
}

class FCMNotificationObject {
  final String title;
  final String body;
  final String type;
  final dynamic data;

  FCMNotificationObject({
    this.title,
    this.body,
    this.type,
    this.data,
  });

  factory FCMNotificationObject.fromJson(Map<String, dynamic> json) {
    if (Platform.isAndroid) {
      var notificationJs = json['notification'] as Map;
      var dataJs = json['data'];
      return FCMNotificationObject(
        title: notificationJs['title'],
        body: notificationJs['body'],
        type: dataJs['type'],
        data: dataJs['data'],
      );
    } else {
      Map notificationJs;
      if (json.containsKey('notification')) {
        notificationJs = json['notification'] as Map;
      } else if (json.containsKey('aps')) {
        notificationJs = json['aps']['alert'] as Map;
      }

      return FCMNotificationObject(
        title: notificationJs['title'],
        body: notificationJs['body'],
        type: json['type'],
        data: json['data'],
      );
    }
  }
}
