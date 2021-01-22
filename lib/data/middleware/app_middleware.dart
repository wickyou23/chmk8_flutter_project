import 'package:chkm8_app/utils/utils.dart';
import 'package:dio/dio.dart';

abstract class AppMiddleware {
  final CancelToken cancelToken = CancelToken();

  void close() {
    cancelToken.cancel();
    appPrint("${this.toString()} closed");
  }
}
