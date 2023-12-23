import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pce/models/chat/get_chat_users_response.dart';
import 'package:pce/models/chat/get_user_chat_image_response.dart';
import 'package:pce/models/chat/get_user_messages_response.dart';
import 'package:pce/screens/chats/chats_repo.dart';

import '../../models/chat/delete_message_response.dart';

class MessageBloc extends Bloc<MessageEventBase, MessageState> {
  MessageBloc() : super(MessageStateEmpty()) {
    on<UserMessagesEvent>(
          (event, emit) async {
       emit(MessageStateLoading());
        try {
          GetUserMessagesResponse response =
          await ChatUsersRepo.instance.getUserMessages(event.body);
          emit(UsersChatStateLoaded(response: response));
        } catch (e) {
          if (e is String) {
            emit(MessageStateError(error: e));
          } else {
            emit(MessageStateError(error: 'Unauthorized'));
          }
        }
      },
    );
    on<UserMessageDeleteEvent>(
          (event, emit) async {
        // emit(MessageStateLoading());
        try {
          DeleteMessageResponse response =
          await ChatUsersRepo.instance.deleteMessage(event.body);
          debugPrint(response.toString());
          emit(UsersChatDeleted(response: response));
        } catch (e) {
          if (e is String) {
            emit(MessageStateError(error: e));
          } else {
            emit(MessageStateError(error: 'Unauthorized'));
          }
        }
      },
    );
    on<UserMessageImageSendEvent>(
          (event, emit) async {
        emit(MessageStateLoading());
        try {
          UserChatImageSendResponse response =
          await ChatUsersRepo.instance.uploadChatImage(event.body,event.userId ?? '');
          debugPrint(response.toString());
          emit(UsersChatImageSendSuccess(response: response,msgResponse: event.response));
        } catch (e) {
          if (e is String) {
            emit(MessageStateError(error: e));
          } else {
            emit(MessageStateError(error: 'Unauthorized'));
          }
        }
      },
    );
  }
}

abstract class MessageEventBase extends Equatable {
  const MessageEventBase();
}

class MessageEvent extends MessageEventBase {
  Map<String, dynamic> body;

  MessageEvent({required this.body});

  @override
  List<Object> get props => [body];
}

class UserMessagesEvent extends MessageEventBase {
  Map<String, dynamic> body;

  UserMessagesEvent({required this.body});

  @override
  List<Object> get props => [body];
}
class UserMessageDeleteEvent extends MessageEventBase {
  Map<String, dynamic> body;

  UserMessageDeleteEvent({required this.body});

  @override
  List<Object> get props => [body];
}

class UserMessageImageSendEvent extends MessageEventBase {
  File body;
  String? userId;
  GetUserMessagesResponse response;

  UserMessageImageSendEvent({required this.body,this.userId,required this.response});

  @override
  List<Object> get props => [body];
}
abstract class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object> get props => [];
}

class MessageStateEmpty extends MessageState {}

class MessageStateLoading extends MessageState {}

class MessageStateError extends MessageState {
  final String error;

  MessageStateError({required this.error});

  @override
  List<Object> get props => [error];
}
//user chats
class UsersChatStateLoaded extends MessageState {
  final GetUserMessagesResponse response;

  const UsersChatStateLoaded({required this.response});

  @override
  List<Object> get props => [response];
}
//user chats send inmages success
class UsersChatImageSendSuccess extends MessageState {
  final UserChatImageSendResponse response;
  final GetUserMessagesResponse msgResponse;

  const UsersChatImageSendSuccess({required this.response,required this.msgResponse});

  @override
  List<Object> get props => [response];
}
class UsersChatDeleted extends MessageState {
  final DeleteMessageResponse response;

  const UsersChatDeleted({required this.response});

  @override
  List<Object> get props => [response];
}