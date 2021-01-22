import 'dart:convert';
import 'package:chkm8_app/data/repository/base_repository.dart';
import 'package:chkm8_app/models/auth_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

AuthUser _auth;

class AuthRepository implements BaseRepository {
  static final AuthRepository _singleton = AuthRepository._internal();

  factory AuthRepository() {
    return _singleton;
  }

  AuthRepository._internal();

  Future<AuthUser> getCurrentUser() async {
    if (_auth == null) {
      SharedPreferences sharePre = await SharedPreferences.getInstance();
      String jsonString = sharePre.getString('AuthUser') ?? '';
      if (jsonString != null && jsonString.isNotEmpty) {
        Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        _auth = AuthUser.fromJson(value: jsonMap);
      }
    }

    return _auth;
  }

  Future<void> setCurrentUser(AuthUser crUser) async {
    SharedPreferences sharePre = await SharedPreferences.getInstance();
    var jsonString = jsonEncode(crUser);
    if (jsonString.isNotEmpty) {
      sharePre.setString('AuthUser', jsonString);
      _auth = crUser;
    }
  }

  @override
  Future<void> clean() async {
    SharedPreferences sharePre = await SharedPreferences.getInstance();
    sharePre.remove('AuthUser');
    _auth = null;
  }
}
