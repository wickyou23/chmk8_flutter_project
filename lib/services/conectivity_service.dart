import 'package:chkm8_app/services/navigation_service.dart';
import 'package:connectivity/connectivity.dart';
import 'package:chkm8_app/utils/extension.dart';

class ConnectivityService {
  static final ConnectivityService _shared = ConnectivityService._internal();
  ConnectivityResult _crState;

  ConnectivityService._internal();

  factory ConnectivityService() {
    return _shared;
  }

  void startService() {
    Connectivity().onConnectivityChanged.listen((event) {
      if (_crState == event) return;

      _crState = event;
      var description = 'Network is connected.';
      if (event == ConnectivityResult.none) {
        description = 'Network was lost.';
      }

      GetService().topScaffold?.currentState?.showCSSnackBar(description);
    });
  }
}
