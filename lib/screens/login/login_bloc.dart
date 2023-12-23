import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pce/models/login/forgot_password.dart';
import 'package:pce/models/user_events/user_events.dart';
import 'package:pce/network/api_provider.dart';
import 'package:pce/screens/login/login_repo.dart';

import '../../models/login/LoginResponse.dart';

class LoginBloc extends Bloc<LoginEventBase, LoginState> {
  LoginBloc() : super(LoginEmpty()) {
    on<LoginEvent>(
      (event, emit) async {
        emit(LoginLoading());
        try {
          LoginResponse response =
              await LoginRepo.instance.login(event.body);
          if (response.data?.userId != null) {
            ApiProvider.instance.setUserDetails(json.encode(response));
            ApiProvider.instance.setProfileUrl(response.data?.imageUrl);
            emit(LoginLoaded(response: response));
          } else {
            emit(LoginError(error: response.msg ?? "Something went wrong!"));
          }
        } catch (e) {
          if (e is String) {
            emit(LoginError(error: e));
          } else {
            emit(LoginError(error: 'Unauthorized'));
          }
        }
      },
    );
    on<EventListEvent>(
          (event, emit) async {
        emit(LoginLoading());
        try {
          UserEvents response =
          await LoginRepo.instance.getUserEvents(event.body);
          if (response.status != null && response.status == true) {
            ApiProvider.instance.setEventDetails(json.encode(response));
            emit(UserEventFetch(response: response));
          } else {
            emit(LoginError(error: "Something went wrong!"));
          }
        } catch (e) {
          if (e is String) {
            emit(LoginError(error: e));
          } else {
            emit(LoginError(error: 'Unauthorized'));
          }
        }
      },
    );
    on<ForgetPasswordEvent>(
          (event, emit) async {
        emit(ForgetPasswordLoading());
        try {
          ForgotPassword response = await LoginRepo.instance.forgotLogin(event.body);
          if (response.status == true) {
            emit(ForgetPasswordDone(response: response));
          } else {
            emit(ForgetPasswordError(error: response.msg ?? "Something went wrong!"));
          }
        } catch (e) {
          if (e is String) {
            emit(ForgetPasswordError(error: e));
          } else {
            emit(ForgetPasswordError(error: 'Unauthorized'));
          }
        }
      },
    );
  }

}

abstract class LoginEventBase extends Equatable {
  const LoginEventBase();
}

class LoginEvent extends LoginEventBase {
  Map<String, dynamic> body;

  LoginEvent({required this.body}) : assert(body != null);

  @override
  List<Object> get props => [body];
}

class EventListEvent extends LoginEventBase {
  Map<String, dynamic> body;

  EventListEvent({required this.body}) : assert(body != null);

  @override
  List<Object> get props => [body];
}
class ForgetPasswordEvent extends LoginEventBase {
  Map<String, dynamic> body;

  ForgetPasswordEvent({required this.body}) : assert(body != null);

  @override
  List<Object> get props => [body];
}
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginEmpty extends LoginState {}

class LoginLoading extends LoginState {}

class LoginLoaded extends LoginState {
  final LoginResponse response;

  const LoginLoaded({required this.response}) : assert(response != null);

  @override
  List<Object> get props => [response];
}

class UserEventFetch extends LoginState {
  final UserEvents response;

  const UserEventFetch({required this.response}) : assert(response != null);

  @override
  List<Object> get props => [response];
}

class LoginError extends LoginState {
  final String error;

  LoginError({required this.error}) : assert(error != null);

  @override
  List<Object> get props => [error];
}

class ForgetPasswordDone extends LoginState {
  final ForgotPassword response;

  const ForgetPasswordDone({required this.response}) : assert(response != null);

  @override
  List<Object> get props => [response];
}

class ForgetPasswordLoading extends LoginState {}


class ForgetPasswordError extends LoginState {
  final String error;

  ForgetPasswordError({required this.error}) : assert(error != null);

  @override
  List<Object> get props => [error];
}