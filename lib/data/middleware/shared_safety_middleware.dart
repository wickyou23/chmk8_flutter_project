import 'package:chkm8_app/data/middleware/app_middleware.dart';
import 'package:chkm8_app/data/network_common.dart';
import 'package:chkm8_app/data/network_response_state.dart';
import 'package:chkm8_app/data/network_url.dart';
import 'package:chkm8_app/models/rating_review_object.dart';
import 'package:dio/dio.dart';

class SharedSafetyMiddleware extends AppMiddleware {
  Future<ResponseState> getMySharedSafetyCode() async {
    try {
      var res = await NetworkCommon().dio.post(
            NetworkUrl.getMySafetySharedCodeURL,
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

  Future<ResponseState> acceptSharedSafetyCode(String code) async {
    try {
      var res = await NetworkCommon().dio.get(
            NetworkUrl.acceptSafetyCodeURL + '/$code',
            cancelToken: this.cancelToken,
          );
      var starJson = res.data.data as Map<String, dynamic> ?? Map();
      if (starJson.isNotEmpty) {
        return ResponseSuccessState(
          statusCode: res.statusCode,
          responseData: RatingReviewObject.fromJson(starJson),
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

  Future<ResponseState> validateSharedSafetyCode(String code) async {
    try {
      var body = {
        'code': code,
        'type': 'SHARE_RATING',
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

  Future<ResponseState> cancelSharedSafetyCode(String code) async {
    try {
      var body = {
        'code': code,
        'type': 'SHARE_RATING',
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
}
