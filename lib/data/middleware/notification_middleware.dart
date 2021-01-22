import 'package:chkm8_app/data/middleware/app_middleware.dart';
import 'package:chkm8_app/data/network_common.dart';
import 'package:chkm8_app/data/network_response_state.dart';
import 'package:chkm8_app/data/network_url.dart';
import 'package:chkm8_app/models/notification_object.dart';
import 'package:dio/dio.dart';

class NotificationMiddleware extends AppMiddleware {
  Future<ResponseState> getNotificationList() async {
    try {
      var res = await NetworkCommon().dio.get(
            NetworkUrl.notificationListURL,
            cancelToken: this.cancelToken,
          );
      var plist = (res.data.data as List)
          .map((e) => NotificationObject.fromJson(e))
          .toList();
      return ResponseSuccessState(
        statusCode: res.statusCode,
        responseData: plist,
      );
    } on DioError catch (e) {
      return ResponseFailedState.fromDioError(e);
    }
  }
}