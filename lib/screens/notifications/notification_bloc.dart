import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pce/models/notification/all_notification_response.dart';
import 'package:pce/screens/agenda/agenda_repo.dart';
import 'package:pce/screens/notifications/notification_repo.dart';

import '../../models/agenda/agenda_response.dart';

class AllNotificationBloc extends Bloc<AllNotificationEventBase, AllNotificationState> {
  AllNotificationBloc() : super(AllNotificationEmpty()) {
    on<FetchNotificationEvent>(
      (event, emit) async {
        emit(AllNotificationLoading());
        try {
          AllNotificationResponse response =
              await AllNotificationRepo.instance.getAllNotifications(event.body);
          if(response.status == true){
            emit(AllNotificationLoaded(response: response));
          }else{
            emit(AllNotificationError(error: response.msg ?? "Something went wrong! please try again"));
          }
        } catch (e) {
          if (e is String) {
            emit(AllNotificationError(error: e));
          } else {
            emit(AllNotificationError(error: 'Unauthorized'));
          }
        }
      },
    );
  }
}

abstract class AllNotificationEventBase extends Equatable {
  const AllNotificationEventBase();
}

class FetchNotificationEvent extends AllNotificationEventBase {
  Map<String, dynamic> body;

  FetchNotificationEvent({required this.body});

  @override
  List<Object> get props => [body];
}

abstract class AllNotificationState extends Equatable {
  const AllNotificationState();

  @override
  List<Object> get props => [];
}

class AllNotificationEmpty extends AllNotificationState {}

class AllNotificationLoading extends AllNotificationState {}

class AllNotificationLoaded extends AllNotificationState {
  final AllNotificationResponse response;

  const AllNotificationLoaded({required this.response});

  @override
  List<Object> get props => [response];
}

class AllNotificationError extends AllNotificationState {
  final String error;

  AllNotificationError({required this.error});

  @override
  List<Object> get props => [error];
}
