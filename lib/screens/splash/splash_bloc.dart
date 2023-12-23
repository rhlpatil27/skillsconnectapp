import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pce/models/login/LoginResponse.dart';
import 'package:pce/network/api_provider.dart';

import '../../models/login/LoginResponse.dart';

class SplashBloc extends Bloc<SplashEventBase, SplashState> {
  SplashBloc() : super(SplashEmpty()) {
    on<SplashEvent>(
      (event, emit) async {
        LoginResponse? response = await ApiProvider.instance.getUserDetails();
        String? eventId = await ApiProvider.instance.getUserEventId();
        if (response != null && eventId != null) {
          emit(SplashLoaded());
        } else {
          emit(const SplashError(msg: 'Please login'));
        }
      },
    );
  }
}

abstract class SplashEventBase extends Equatable {
  const SplashEventBase();
}

class SplashEvent extends SplashEventBase {
  final String fcmId;

  const SplashEvent({required this.fcmId}) : assert(fcmId != null);

  @override
  List<Object> get props => [fcmId];
}

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object> get props => [];
}

class SplashEmpty extends SplashState {}

class SplashLoading extends SplashState {}

class SplashLoaded extends SplashState {
  const SplashLoaded();

  @override
  List<Object> get props => [];
}

class SplashError extends SplashState {
  final String msg;

  const SplashError({required this.msg}) : assert(msg != null);

  @override
  List<Object> get props => [msg];
}
