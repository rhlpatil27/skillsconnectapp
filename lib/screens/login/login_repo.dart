
import 'package:pce/models/login/LoginResponse.dart';
import 'package:pce/models/login/forgot_password.dart';
import 'package:pce/models/user_events/update_details_model.dart';
import 'package:pce/models/user_events/user_events.dart';

import '../../models/login/LoginResponse.dart';
import '../../models/user_events/my_profile.dart';
import '../../network/api_provider.dart';

class LoginRepo {
  LoginRepo._privateConstructor();

  static final LoginRepo instance = LoginRepo._privateConstructor();

  Future<LoginResponse> login(Map<String, dynamic>? body) async {
    final response = await ApiProvider.instance.post("login", body);
    return LoginResponse.fromJson(response);
  }
  Future<ForgotPassword> forgotLogin(Map<String, dynamic>? body) async {
    final response = await ApiProvider.instance.post("forgot_password", body);
    return ForgotPassword.fromJson(response);
  }
  Future<UserEvents> getUserEvents(Map<String, dynamic>? body) async {
    final response = await ApiProvider.instance.post("get_user_events", body);
    return UserEvents.fromJson(response);
  }

  Future<MyProfileModel> getUserDetails(String? userId) async {
    final response = await ApiProvider.instance.get("get_user/$userId");
    return MyProfileModel.fromJson(response);
  }
  Future<UpdateDetailsModel> exportLeads(Map<String, dynamic>? body) async {
    final response = await ApiProvider.instance.post("export_leads",body);
    return UpdateDetailsModel.fromJson(response);
  }
}
