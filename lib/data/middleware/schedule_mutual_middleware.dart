import 'package:chkm8_app/data/middleware/app_middleware.dart';
import 'package:chkm8_app/data/network_common.dart';
import 'package:chkm8_app/data/network_response_state.dart';
import 'package:chkm8_app/data/network_url.dart';
import 'package:chkm8_app/models/schedule_mutual_object.dart';
import 'package:dio/dio.dart';

class ScheduleMutualMiddleware extends AppMiddleware {
  Future<ResponseState> getMySharedScheduleCode(
      int time, String nickName) async {
    try {
      var body = {
        'time': time,
        'nickName': nickName,
      };

      var res = await NetworkCommon().dio.post(
            NetworkUrl.getMyScheduleMutualCodeURL,
            data: body,
            cancelToken: this.cancelToken,
          );
      var code = res.data.data as String ?? '';
      if (code.isNotEmpty) {
        return ResponseSuccessState(
          statusCode: res.statusCode,
          responseData: code,
        );
      } else {
        return ResponseFailedState(
          statusCode: -1,
          errorMessage: 'Data Error!',
        );
      }
    } on DioError catch (e) {
      return ResponseFailedState.fromDioError(e);
    }
  }

  Future<ResponseState> acceptSharedScheduleCode(String code) async {
    try {
      var res = await NetworkCommon().dio.get(
            NetworkUrl.getMyScheduleMutualCodeURL + '/$code',
            cancelToken: this.cancelToken,
          );
      var scheduleJson = res.data.data as Map<String, dynamic> ?? Map();
      if (scheduleJson.isNotEmpty) {
        var scheduleObj = ScheduleMutualObject.fromJson(scheduleJson);
        return ResponseSuccessState(
          statusCode: res.statusCode,
          responseData: scheduleObj,
        );
      } else {
        return ResponseFailedState(
          statusCode: -1,
          errorMessage: 'Data Error!',
        );
      }
    } on DioError catch (e) {
      return ResponseFailedState.fromDioError(e);
    }
  }

  Future<ResponseState> cancelSharedScheduleCode(String code) async {
    try {
      var body = {
        'code': code,
        'type': 'SCHEDULING_RATING',
      };

      var res = await NetworkCommon().dio.post(
            NetworkUrl.cancelInvitationURL,
            data: body,
          );
      return ResponseSuccessState(
        statusCode: res.statusCode,
        responseData: '',
      );
    } on DioError catch (e) {
      return ResponseFailedState.fromDioError(e);
    }
  }

  Future<ResponseState> validateScheduleSharedCode(String code) async {
    try {
      var body = {
        'code': code,
        'type': 'SCHEDULING_RATING',
      };

      var res = await NetworkCommon().dio.post(
            NetworkUrl.validateCodeURL,
            data: body,
            cancelToken: this.cancelToken,
          );
      return ResponseSuccessState(
        statusCode: res.statusCode,
        responseData: '',
      );
    } on DioError catch (e) {
      return ResponseFailedState.fromDioError(e);
    }
  }

  Future<ResponseState> setScheduleRemindRating(String id, int time) async {
    try {
      var body = {
        'id': id,
        'time': time,
      };

      // TODO - TO TEST
      // var body = {
      //   'id': id,
      //   'time':
      //       DateTime.now().add(Duration(seconds: 10)).millisecondsSinceEpoch,
      // };

      var res = await NetworkCommon().dio.post(
            NetworkUrl.getScheduleRemindRatingURL,
            data: body,
          );
      return ResponseSuccessState(
        statusCode: res.statusCode,
        responseData: '',
      );
    } on DioError catch (e) {
      return ResponseFailedState.fromDioError(e);
    }
  }

  Future<ResponseState> checkScheduleRated(String scheduleId) async {
    try {
      var res = await NetworkCommon().dio.get(
            NetworkUrl.checkScheduleRated + '/$scheduleId',
            cancelToken: this.cancelToken,
          );
      var scheduleJson = res.data.data as Map<String, dynamic> ?? Map();
      return ResponseSuccessState(
        statusCode: res.statusCode,
        responseData: scheduleJson['rated'] ?? false,
      );
    } on DioError catch (e) {
      return ResponseFailedState.fromDioError(e);
    }
  }
}
