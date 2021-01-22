import 'dart:io';

import 'package:chkm8_app/enum/network_error_enum.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

abstract class ResponseState {
  final int statusCode;

  ResponseState({@required this.statusCode});
}

class ResponseSuccessState<T> extends ResponseState {
  final T responseData;

  ResponseSuccessState({@required int statusCode, @required this.responseData})
      : super(statusCode: statusCode);

  ResponseSuccessState<T> copyWith({int statusCode, T responseData}) {
    return ResponseSuccessState<T>(
      statusCode: statusCode ?? this.statusCode,
      responseData: responseData ?? this.responseData,
    );
  }
}

class ResponseFailedState extends ResponseState {
  final NWErrorEnum apiError;
  final String errorMessage;

  ResponseFailedState({
    @required int statusCode,
    @required this.errorMessage,
    this.apiError,
  }) : super(statusCode: statusCode);

  factory ResponseFailedState.fromDioError(DioError e) {
    var dataError = e.error;
    if (dataError is NWErrorEnum) {
      return ResponseFailedState(
        statusCode: e.response.statusCode,
        errorMessage: dataError.errorMessage,
        apiError: dataError,
      );
    } else if (dataError is SocketException) {
      var osError = dataError.osError;
      if (osError.errorCode == 101 || osError.errorCode == 51) {
        return ResponseFailedState(
          statusCode: osError.errorCode,
          errorMessage: osError.message,
        );
      }
    }
    
    return ResponseFailedState(
      statusCode: e.response?.statusCode ?? -1,
      errorMessage: 'An error occurred. Please try again.',
    );
  }
}
