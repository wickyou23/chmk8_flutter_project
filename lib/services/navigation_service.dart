import 'package:flutter/material.dart';

class GetService {
  static final GetService _singleton = GetService._internal();

  GetService._internal();

  factory GetService() {
    return _singleton;
  }

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final List<GlobalKey<ScaffoldState>> _scQueue = [];

  GlobalKey<ScaffoldState> get topScaffold {
    if (_scQueue.isEmpty) return null;
    return _scQueue.last;
  }

  void addScaffold(GlobalKey<ScaffoldState> newSC) {
    if (newSC == null) return;
    _scQueue.add(newSC);
  }

  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState.pushNamed(routeName);
  }

  Future<dynamic> navigateAndReplaceTo(String routeName) {
    return navigatorKey.currentState.pushReplacementNamed(routeName);
  }

  void removeScaffoldKey(GlobalKey<ScaffoldState> scKey) {
    _scQueue.removeWhere((element) => element == scKey);
  }
}
