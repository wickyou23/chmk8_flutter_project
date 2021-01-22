import 'dart:convert';
import 'package:chkm8_app/enum/notification_type_enum.dart';
import 'package:uuid/uuid.dart';
import 'package:chkm8_app/utils/extension.dart';

class NotificationObject {
  final String id;
  final String title;
  final String content;
  final String type;
  final String objId;
  final Map<String, dynamic> params;
  final int time;
  final int status;

  NotificationObject({
    this.id = '',
    this.title = '',
    this.content = '',
    this.type = '',
    this.objId = '',
    this.params,
    this.time = 0,
    this.status = 0,
  });

  factory NotificationObject.fromJson(Map<String, dynamic> map) {
    Map<String, dynamic> mapParam = jsonDecode(map['params'] ?? '');

    return NotificationObject(
      id: map['id'] ?? Uuid().v4(),
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      type: map['notificationType'] ?? '',
      time: map['createdTime'] ?? 0,
      objId: map['objId'] ?? '',
      params: mapParam,
      status: map['status'] ?? 0,
    );
  }

  NotificationType get notiType {
    return NotificationTypeExt.initRawValue(this.type);
  }

  DateTime get createTime {
    return DateTime.fromMillisecondsSinceEpoch(this.time);
  }

  String get nickName {
    return this.params['nickName'] ?? '';
  }

  String get timeAgo {
    int now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    int create = this.time ~/ 1000;
    if (this.createTime.isToday()) {
      int remain = now - create;
      if (remain < 60) {
        return 'Now';
      } else if ((remain ~/ 60) < 60) {
        int minute = remain ~/ 60;
        return minute <= 1 ? '$minute min ago' : '$minute mins ago';
      } else if ((remain ~/ 3600) < 24) {
        int hours = remain ~/ 3600;
        return '$hours hrs ago';
      } else {
        return '';
      }
    } else if (this.createTime.isYesterday()) {
      return 'Yesterday';
    } else {
      return this.createTime.csToString('MM-dd-yyyy');
    }
  }
}
