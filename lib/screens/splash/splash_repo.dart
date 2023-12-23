
import 'package:pce/models/login/LoginResponse.dart';

import '../../models/login/LoginResponse.dart';
import '../../network/api_provider.dart';

class LoginRepo {
  LoginRepo._privateConstructor();

  static final LoginRepo instance = LoginRepo._privateConstructor();

  Future<LoginResponse> login(Map<String, dynamic>? body) async {
    final response = await ApiProvider.instance.post("login", body);
    return LoginResponse.fromJson(response);
  }
}
