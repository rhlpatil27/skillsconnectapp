import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pce/models/QrCode/QrCodeDetails.dart';
import 'package:pce/models/fcm_key_update/fcm_key_update.dart';
import 'package:pce/models/user_events/user_events.dart';
import 'package:pce/network/api_provider.dart';
import 'package:pce/screens/login/login_repo.dart';
import 'package:pce/screens/qr/qr_repo.dart';
import 'package:pce/screens/select_event/fcm_update_repo.dart';

import '../../models/login/LoginResponse.dart';

class FcmUpdateBloc extends Bloc<FcmEventBase, FcmUpdateState> {
  FcmUpdateBloc() : super(FcmKeyUpdateEmpty()) {
    on<FcmKeyUpdateEvent>(
      (event, emit) async {
        emit(FcmKeyUpdateLoading());
        try {
           FcmKeyUpdate response = await FcmKeyUpdateRepo.instance.updateFcmToken(event.body);
          if (response.status == true){
              emit(FcmKeyUpdateDone(response: response));
          } else {
            emit(FcmKeyUpdateFailed(error: response.msg ?? "Something went wrong!"));
          }
        } catch (e) {
          if (e is String) {
            emit(FcmKeyUpdateFailed(error: e));
          } else {
            emit(FcmKeyUpdateFailed(error: 'Unauthorized'));
          }
        }
      },
    );
  }

}

abstract class FcmEventBase extends Equatable {
  const FcmEventBase();
}

class FcmKeyUpdateEvent extends FcmEventBase {
  Map<String, dynamic> body;

  FcmKeyUpdateEvent({required this.body}) : assert(body != null);

  @override
  List<Object> get props => [body];
}

abstract class FcmUpdateState extends Equatable {
  const FcmUpdateState();

  @override
  List<Object> get props => [];
}

class FcmKeyUpdateEmpty extends FcmUpdateState {}

class FcmKeyUpdateLoading extends FcmUpdateState {}

class FcmKeyUpdateDone extends FcmUpdateState {
  final FcmKeyUpdate response;

  const FcmKeyUpdateDone({required this.response}) : assert(response != null);

  @override
  List<Object> get props => [response];
}

class FcmKeyUpdateFailed extends FcmUpdateState {
  final String error;

  FcmKeyUpdateFailed({required this.error}) : assert(error != null);

  @override
  List<Object> get props => [error];
}
