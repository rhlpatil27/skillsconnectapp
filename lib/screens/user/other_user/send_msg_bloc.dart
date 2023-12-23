import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pce/models/QrCode/QrCodeDetails.dart';
import 'package:pce/models/send_msg/send_msg.dart';
import 'package:pce/models/user_events/user_events.dart';
import 'package:pce/network/api_provider.dart';
import 'package:pce/screens/login/login_repo.dart';
import 'package:pce/screens/qr/qr_repo.dart';
import 'package:pce/screens/user/other_user/send_msg_repo.dart';

class SendMsgBloc extends Bloc<SendMsgEventBase, SendMsgState> {
  SendMsgBloc() : super(SendMsgEmpty()) {
    on<SendMsgButtonEvent>(
      (event, emit) async {
        emit(SendMsgLoading());
        try {
          SendNotification response;
          if(event.flag == 0){
           response = await SendMsgRepo.instance.addNote(event.body);
          }else{
           response = await SendMsgRepo.instance.addMessage(event.body);
          }
          if (response.status == true){
            emit(SendMsgLoaded(response: response));
          } else {
            emit(SendMsgFailed(error: "Something went wrong!"));
          }
        } catch (e) {
          if (e is String) {
            emit(SendMsgFailed(error: e));
          } else {
            emit(SendMsgFailed(error: 'Unauthorized'));
          }
        }
      },
    );
  }

}

abstract class SendMsgEventBase extends Equatable {
  const SendMsgEventBase();
}

class SendMsgButtonEvent extends SendMsgEventBase {
  Map<String, dynamic> body;
  int flag;
  SendMsgButtonEvent({required this.body,required this.flag}) : assert(body != null);

  @override
  List<Object> get props => [body];
}

abstract class SendMsgState extends Equatable {
  const SendMsgState();

  @override
  List<Object> get props => [];
}

class SendMsgEmpty extends SendMsgState {}

class SendMsgLoading extends SendMsgState {}

class SendMsgLoaded extends SendMsgState {
  final SendNotification response;

  const SendMsgLoaded({required this.response}) : assert(response != null);

  @override
  List<Object> get props => [response];
}

class SendMsgFailed extends SendMsgState {
  final String error;

  SendMsgFailed({required this.error}) : assert(error != null);

  @override
  List<Object> get props => [error];
}
