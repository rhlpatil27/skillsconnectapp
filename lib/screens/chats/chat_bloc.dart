import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pce/models/chat/get_chat_users_response.dart';
import 'package:pce/models/chat/get_user_messages_response.dart';
import 'package:pce/screens/chats/chats_repo.dart';

class ChatUsersBloc extends Bloc<ChatUsersEventBase, ChatUsersState> {
  ChatUsersBloc() : super(ChatUsersStateEmpty()) {
    on<ChatUsersEvent>(
          (event, emit) async {
        emit(ChatUsersStateLoading());
        try {
          GetChatUsersResponse response =
          await ChatUsersRepo.instance.getAllChatUsers(event.body);
          emit(ChatUsersStateLoaded(response: response));
        } catch (e) {
          if (e is String) {
            emit(ChatUsersStateError(error: e));
          } else {
            emit(ChatUsersStateError(error: 'Unauthorized'));
          }
        }
      },
    );

    on<UpdateUnReadCount>(
          (event, emit) {
        // emit(ChatUsersStateLoading());
        try {
          for(int i = 0; i < event.response.data.length; i++){
            if(event.userID == event.response.data[i].id){
              event.response.data[i].unreadCount = event.unreadCount;
              emit(ChatUsersStateLoaded(response: event.response));
              return;
            }
          }
        } catch (e) {
          if (e is String) {
            // emit(ChatUsersStateError(error: e));
          } else {
            // emit(ChatUsersStateError(error: 'Unauthorized'));
          }
        }
      },
    );
    on<SearchChatUser>(
          (event, emit) {
        // emit(ChatUsersStateLoading());
        try {
          List<Data> listData = [];
          // if(event.searchText.compareTo("NA") == 0){
          //   GetChatUsersResponse response = event.response;
          //   emit(SearchUsersStateLoaded(response: response));
          //   return;
          // }else{
            GetChatUsersResponse response = event.response;
            for(int i = 0; i < response.data.length; i++){
              if(response.data[i].name.toLowerCase().contains(event.searchText.trim().toLowerCase())){
                listData.add(response.data[i]);
              }
            }
            response.data.clear();
            response.data.addAll(listData);
            emit(SearchUsersStateLoaded(response: response));
            return;
          // }

        } catch (e) {
          if (e is String) {
            emit(ChatUsersStateError(error: e));
          } else {
            // emit(ChatUsersStateError(error: 'Unauthorized'));
          }
        }
      },
    );
  }
}

abstract class ChatUsersEventBase extends Equatable {
  const ChatUsersEventBase();
}

class ChatUsersEvent extends ChatUsersEventBase {
  Map<String, dynamic> body;

  ChatUsersEvent({required this.body});

  @override
  List<Object> get props => [body];
}
/// new event for update unread count
class UpdateUnReadCount extends ChatUsersEventBase {
  late final GetChatUsersResponse response;
  final String userID;
  final String unreadCount;

  UpdateUnReadCount(this.userID, this.unreadCount, {required this.response});

  @override
  List<Object> get props => [response];
}

/// new event for search chat person
class SearchChatUser extends ChatUsersEventBase {
  late final GetChatUsersResponse response;
  final String searchText;

  SearchChatUser(this.searchText, {required this.response});

  @override
  List<Object> get props => [response];
}

abstract class ChatUsersState extends Equatable {
  const ChatUsersState();

  @override
  List<Object> get props => [];
}

class ChatUsersStateEmpty extends ChatUsersState {}

class ChatUsersStateLoading extends ChatUsersState {}

class ChatUsersStateLoaded extends ChatUsersState {
   GetChatUsersResponse response;
   ChatUsersStateLoaded({required this.response});

  @override
  List<Object> get props => [response];
}
class SearchUsersStateLoaded extends ChatUsersState {
  GetChatUsersResponse response;
  SearchUsersStateLoaded({required this.response});

  @override
  List<Object> get props => [response];
}
class ChatUsersStateError extends ChatUsersState {
  final String error;

  ChatUsersStateError({required this.error});

  @override
  List<Object> get props => [error];
}
