import 'dart:async';
import 'package:flutter/cupertino.dart';

class NotificationName {
  static const HOME_SCREEN_CHANGE_TAB = "HOME_SCREEN_CHANGE_TAB";
  static const NEW_NOTIFICATION = "NEW_NOTIFICATION";
  static const NEED_TO_RELOAD_NOTIFICATION = "NEED_TO_RELOAD_NOTIFICATION";
}

class NotificationService {
  static final NotificationService _shared = NotificationService._internal();

  NotificationService._internal();

  factory NotificationService() {
    return _shared;
  }

  final StreamController<NotificationServiceObject> _controller =
      StreamController<NotificationServiceObject>.broadcast();

  void add(String name, {dynamic value}) {
    _controller.add(
      NotificationServiceObject(
        name: name,
        value: value,
      ),
    );
  }

  StreamSubscription<NotificationServiceObject> listen(
      void Function(NotificationServiceObject) event) {
    return _controller.stream.listen(event);
  }
}

class NotificationServiceObject {
  final String name;
  final dynamic value;

  NotificationServiceObject({
    @required this.name,
    @required this.value,
  });
}
