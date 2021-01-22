import 'package:chkm8_app/enum/network_error_enum.dart';
import 'package:flutter/foundation.dart';

class NWResponseObject {
  final int status;
  final NWErrorEnum error;
  final dynamic data;

  NWResponseObject({
    @required this.status,
    @required this.error,
    @required this.data,
  });

  factory NWResponseObject.formJson({@required Map<String, dynamic> json}) {
    var errorInt = json['error'] as int ?? -1;
    return NWResponseObject(
      status: json['status'],
      error: NWErrorEnumExt.initRawValue(errorInt),
      data: json['data'],
    );
  }
}
