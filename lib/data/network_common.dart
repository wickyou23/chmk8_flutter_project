import 'dart:convert';
import 'dart:io';
import 'package:chkm8_app/channels/utils_native_channel.dart';
import 'package:chkm8_app/data/network_url.dart';
import 'package:chkm8_app/services/local_store_service.dart';
import 'package:chkm8_app/utils/utils.dart';
import 'package:chkm8_app/wireframe.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'network_response_object.dart';
import 'package:chkm8_app/models/auth_user.dart';

class NetworkCommon {
  static final NetworkCommon _singleton = new NetworkCommon._internal();

  factory NetworkCommon() {
    return _singleton;
  }

  NetworkCommon._internal();

  final JsonDecoder _decoder = new JsonDecoder();

  Dio get dio {
    Dio dio = new Dio();

    //Set default configs
    this.checkForCharlesProxy(dio);
    dio.options.baseUrl = NetworkUrl.baseURL;
    dio.options.connectTimeout = 10000;
    dio.options.receiveTimeout = 10000;
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options) async {
          final String currentTimeZone =
              await UtilsNativeChannel().getCityTimeZone();
          var user = LocalStoreService().currentUser;
          Map<String, dynamic> headers = options.headers;
          headers.update(
            'Authorization',
            (_) => user.fullAccessToken,
            ifAbsent: () => user.fullAccessToken,
          );
          headers.update(
            'timezone',
            (value) => currentTimeZone,
            ifAbsent: () => currentTimeZone,
          );
          options.headers = headers;
          options.toLog();
          return options; //continue
        },
        onResponse: (Response response) async {
          response.toLog();
          return decodeRespSuccess(response); // continue
        },
        onError: (DioError e) async {
          e.toLog();
          if (e.response?.statusCode == 401) {
            AppWireFrame.logout();
            return e;
          }

          if (CancelToken.isCancel(e)) return e;

          var repoObj = decodeRespFailed(e.response);
          if (repoObj == null) return e;
          if (repoObj.error == null) return e;

          e.error = repoObj.error;
          return e;
        },
      ),
    );

    return dio;
  }

  Dio get authDio {
    Dio dio = new Dio();

    //Set default configs
    this.checkForCharlesProxy(dio);
    dio.options.baseUrl = NetworkUrl.baseURL;
    dio.options.connectTimeout = 10000;
    dio.options.receiveTimeout = 10000;
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options) async {
          final String currentTimeZone =
              await UtilsNativeChannel().getCityTimeZone();
          Map<String, dynamic> headers = options.headers;
          headers.update(
            'timezone',
            (value) => currentTimeZone,
            ifAbsent: () => currentTimeZone,
          );
          options.headers = headers;
          options.toLog();
          return options;
        },
        onResponse: (Response response) async {
          response.toLog();
          return decodeRespSuccess(response);
        },
        onError: (DioError e) {
          e.toLog();
          if (CancelToken.isCancel(e)) return e;

          var repoObj = decodeRespFailed(e.response);
          if (repoObj == null) return e;
          if (repoObj.error == null) return e;

          e.error = repoObj.error;
          return e;
        },
      ),
    );

    return dio;
  }

  NWResponseObject decodeRespSuccess(d) {
    if (d is Response) {
      final dynamic jsonBody = d.data;
      final statusCode = d.statusCode;

      if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        throw new Exception("statusCode: $statusCode");
      }

      if (jsonBody is String) {
        if (jsonBody.isEmpty && statusCode == 200) {
          return NWResponseObject(
            status: statusCode,
            data: '',
            error: null,
          );
        }

        return NWResponseObject.formJson(
          json: _decoder.convert(jsonBody),
        );
      } else {
        return NWResponseObject.formJson(json: jsonBody);
      }
    } else {
      throw d;
    }
  }

  NWResponseObject decodeRespFailed(d) {
    if (d is Response) {
      final dynamic jsonBody = d.data;
      if (jsonBody is String) {
        if (jsonBody.isEmpty) return null;

        return NWResponseObject.formJson(
          json: _decoder.convert(jsonBody),
        );
      } else if (jsonBody is Map) {
        return NWResponseObject.formJson(json: jsonBody);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  void checkForCharlesProxy(Dio dio) {
    const charlesIp = '';
    if (charlesIp.isEmpty) return;
    appPrint('#CharlesProxyEnabled');
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.findProxy = (uri) => "PROXY $charlesIp:8888;";
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    };
  }
}

extension RequestOptionsExt on RequestOptions {
  void toLog() {
    String log = '===== [SEND][${this.method}][${this.path}] =====\n';
    log += '[SEND][URL]: ${this.baseUrl}${this.path}\n';
    log += '[SEND][ReqHeader]: ${this.headers.toString()}\n';
    if (this.queryParameters != null && this.queryParameters.isNotEmpty) {
      log += '[SEND][QueryParam]: ${this.queryParameters.toString()}\n';
    }

    if (this.data != null) {
      log += '[SEND][ReqBody]: ${this.data.toString()}';
    }

    appPrint(log);
  }
}

extension ResponseExt on Response {
  void toLog() {
    String log = '===== [RESPONSE][${this.request.uri.path}] =====\n';
    log += '[RESPONSE][SUCCESS]: ${this.toString()}';
    appPrint(log);
  }
}

extension DioErrorExt on DioError {
  void toLog() {
    String log = '===== [RESPONSE][${this.request.uri.path}] =====\n';
    if (CancelToken.isCancel(this)) {
      log += '[RESPONSE][CANCELED]: ${this.toString()}';
    } else {
      log += '[RESPONSE][FAILED]: ${this.toString()}';

      String repoString = this.response?.toString() ?? '';
      if (repoString.isNotEmpty) {
        log += '\n';
        log += '[RESPONSE][FAILED][DATA]: $repoString';
      }
    }

    appPrint(log);
  }
}
