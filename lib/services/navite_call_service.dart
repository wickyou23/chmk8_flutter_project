import 'package:flutter/services.dart';

class NativeCallService {
  static final NativeCallService _shared = NativeCallService._internal();

  NativeCallService._internal();

  factory NativeCallService() {
    return _shared;
  }

  final nativeCallPlatform =
      const MethodChannel('flutter.sailebotv2.nativeCall');

  Future<void> callPhoneNumber(String phoneNumber) async {
    try {
      await nativeCallPlatform
          .invokeMethod('makePhoneCall', phoneNumber);
    } on PlatformException catch (e) {
      throw (e.message);
    }
  }
}
