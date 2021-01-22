import 'dart:convert';

import 'package:chkm8_app/data/middleware/app_middleware.dart';
import 'package:chkm8_app/data/network_common.dart';
import 'package:chkm8_app/data/network_response_state.dart';
import 'package:chkm8_app/data/network_url.dart';
import 'package:chkm8_app/data/repository/rating_repository.dart';
import 'package:chkm8_app/models/history_rating_object.dart';
import 'package:chkm8_app/models/lastest_accept_object.dart';
import 'package:dio/dio.dart';

class RatingMiddleware extends AppMiddleware {
  Future<ResponseState> submitRating(RatingRepository ratingRepo) async {
    try {
      var res = await NetworkCommon().dio.post(
            NetworkUrl.ratingURL,
            data: ratingRepo.toJson(),
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

  Future<ResponseState> getPendingRatingList() async {
    try {
      var res = await NetworkCommon().dio.get(
            NetworkUrl.pendingRateURL,
            cancelToken: this.cancelToken,
          );
      var plist = (res.data.data as List)
          .map((e) => HistoryRatingObject.fromJson(e))
          .toList();
      return ResponseSuccessState(
        statusCode: res.statusCode,
        responseData: plist,
      );
    } on DioError catch (e) {
      return ResponseFailedState.fromDioError(e);
    }
  }

  Future<ResponseState> getGivenRatingList() async {
    try {
      var res = await NetworkCommon().dio.get(
            NetworkUrl.givenRateURL,
          );
      var plist = (res.data.data as List)
          .map((e) => HistoryRatingObject.fromJson(e))
          .toList();
      return ResponseSuccessState(
        statusCode: res.statusCode,
        responseData: plist,
      );
    } on DioError catch (e) {
      return ResponseFailedState.fromDioError(e);
    }
  }

  Future<ResponseState> getLastestAccept() async {
    try {
      var res = await NetworkCommon().dio.post(
            NetworkUrl.ratingLastestAcceptURL,
          );
      var map;
      var rpData = res.data.data;
      if (rpData is String) {
        if (rpData.isNotEmpty) {
          map = jsonDecode(rpData);
        }
      } else if (rpData is Map) {
        map = rpData;
      }

      if (map != null) {
        return ResponseSuccessState(
          statusCode: res.statusCode,
          responseData: LastestAcceptObject.fromJson(map),
        );
      } else {
        return ResponseFailedState(
          statusCode: -1,
          errorMessage: 'Empty',
        );
      }
    } on DioError catch (e) {
      return ResponseFailedState.fromDioError(e);
    }
  }
}
