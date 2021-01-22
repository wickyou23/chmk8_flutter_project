import 'dart:io';
import 'package:chkm8_app/data/middleware/app_middleware.dart';
import 'package:chkm8_app/data/network_response_object.dart';
import 'package:chkm8_app/enum/gender_enum.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../network_common.dart';
import '../network_response_state.dart';
import '../network_url.dart';
import '../../models/auth_user.dart';

class AuthMiddleware extends AppMiddleware {
  Future<ResponseState> signup({
    @required String phone,
    @required String countryCode,
  }) async {
    try {
      var body = {
        'phone': phone,
        'countryCode': countryCode,
        'type': 'SIGNUP',
      };
      var res = await NetworkCommon().authDio.post(
            NetworkUrl.signupURL,
            data: body,
            cancelToken: this.cancelToken,
          );
      var phoneNumber = res.data.data as String ?? '';
      if (phoneNumber.isNotEmpty) {
        return ResponseSuccessState(
          statusCode: res.statusCode,
          responseData: AuthUser(
            phone: phoneNumber,
            countryCode: countryCode,
          ),
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

  Future<ResponseState> signin({
    @required String phone,
    @required String countryCode,
  }) async {
    try {
      var body = {
        'phone': phone,
        'countryCode': countryCode,
        'type': 'LOGIN',
      };
      var res = await NetworkCommon().authDio.post<NWResponseObject>(
            NetworkUrl.signinURL,
            data: body,
            cancelToken: this.cancelToken,
          );
      var phoneNumber = res.data.data as String ?? '';
      if (phoneNumber.isNotEmpty) {
        return ResponseSuccessState(
          statusCode: res.statusCode,
          responseData: AuthUser(
            phone: phoneNumber,
            countryCode: countryCode,
          ),
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

  Future<ResponseState> verifyOtpCode({
    @required String phone,
    @required String otpCode,
  }) async {
    try {
      var body = {
        'phone': phone,
        'otp': otpCode,
      };
      var res = await NetworkCommon().authDio.post<NWResponseObject>(
            NetworkUrl.verityCodeURL,
            data: body,
            cancelToken: this.cancelToken,
          );
      var data = res.data.data as Map<String, dynamic>;
      if (data.isNotEmpty) {
        return ResponseSuccessState(
          statusCode: res.statusCode,
          responseData: AuthUser.fromJson(value: data),
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

  Future<ResponseState> submitNotificationToken({
    @required String deviceId,
    @required String fcmToken,
  }) async {
    try {
      var body = {
        'os': (Platform.isIOS) ? 'IOS' : 'ANDROID',
        'deviceId': deviceId,
        'token': fcmToken,
      };
      var res = await NetworkCommon().dio.post<NWResponseObject>(
            NetworkUrl.submitNotificationTokenURL,
            data: body,
            cancelToken: this.cancelToken,
          );
      return ResponseSuccessState(
        statusCode: res.statusCode,
        responseData: fcmToken,
      );
    } on DioError catch (e) {
      return ResponseFailedState.fromDioError(e);
    }
  }

  Future<ResponseState> getMyRating() async {
    try {
      var res = await NetworkCommon().dio.get(
            NetworkUrl.myRatingURL,
            cancelToken: this.cancelToken,
          );
      var profileJS = res.data.data as Map;
      var myProfile = AuthUser.fromJson(value: profileJS);
      return ResponseSuccessState(
        statusCode: res.statusCode,
        responseData: myProfile,
      );
    } on DioError catch (e) {
      return ResponseFailedState.fromDioError(e);
    }
  }

  Future<ResponseState> selectGender({@required Gender gender}) async {
    try {
      var body = {
        'gender': gender.rawValue
      };

      var res = await NetworkCommon().dio.post(
            NetworkUrl.updateProfileURL,
            data: body,
            cancelToken: this.cancelToken,
          );
      return ResponseSuccessState(
        statusCode: res.statusCode,
        responseData: true,
      );
    } on DioError catch (e) {
      return ResponseFailedState.fromDioError(e);
    }
  }

  Future<ResponseState> getMyProfile() async {
    try {
      var res = await NetworkCommon().dio.get(
            NetworkUrl.myProfileURL,
          );
      var profileJS = res.data.data as Map;
      var myProfile = AuthUser.fromJson(value: profileJS);
      return ResponseSuccessState(
        statusCode: res.statusCode,
        responseData: myProfile,
      );
    } on DioError catch (e) {
      return ResponseFailedState.fromDioError(e);
    }
  }
}
