import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pce/models/user_events/user_events.dart';
import 'package:pce/screens/agenda/agenda_repo.dart';

 import '../../models/user_events/my_profile.dart';
import '../../models/user_events/update_details_model.dart';
import '../../network/api_provider.dart';
import '../login/login_repo.dart';

class MyProfileBloc extends Bloc<MyProfileEventBase, MyProfileState> {
  MyProfileBloc() : super(MyProfileEmpty()) {
    on<MyProfileEvent>((event, emit) async {
        emit(MyProfileLoading());
        try {
          String? userId = await ApiProvider.instance.getUserId();
          MyProfileModel response =
          await LoginRepo.instance.getUserDetails(userId ?? "2986"); //userId ??
          emit(MyProfileLoaded(response: response));
        } catch (e) {
          if (e is String) {
            emit(MyProfileError(error: e));
          } else {
            emit(MyProfileError(error: 'Unauthorized'));
          }
        }
      },
    );

    on<ExportLeadsEvent>(
          (event, emit) async {
        emit(ExportLeadsLoading());
        try {
          UpdateDetailsModel response =
          await LoginRepo.instance.exportLeads(event.body); //userId ??
          emit(ExportLeadsLoaded(response: response));
        } catch (e) {
          if (e is String) {
            emit(ExportLeadsError(error: e));
          } else {
            emit(ExportLeadsError(error: 'Unauthorized'));
          }
        }
      },
    );
  }
}

abstract class MyProfileEventBase extends Equatable {
  const MyProfileEventBase();
}

class MyProfileEvent extends MyProfileEventBase {
  Map<String, dynamic> body;

  MyProfileEvent({required this.body});

  @override
  List<Object> get props => [body];
}

abstract class MyProfileState extends Equatable {
  const MyProfileState();

  @override
  List<Object> get props => [];
}

class MyProfileEmpty extends MyProfileState {}

class MyProfileLoading extends MyProfileState {}

class MyProfileLoaded extends MyProfileState {
  final MyProfileModel response;

  const MyProfileLoaded({required this.response});

  @override
  List<Object> get props => [response];
}

class MyProfileError extends MyProfileState {
  final String error;

  MyProfileError({required this.error});

  @override
  List<Object> get props => [error];
}
 /// EXPORT LEADS

class ExportLeadsEvent extends MyProfileEventBase {
  Map<String, dynamic> body;

  ExportLeadsEvent({required this.body});

  @override
  List<Object> get props => [body];
}

class ExportLeadsEmpty extends MyProfileState {}

class ExportLeadsLoading extends MyProfileState {}

class ExportLeadsLoaded extends MyProfileState {
  final UpdateDetailsModel response;

  const ExportLeadsLoaded({required this.response});

  @override
  List<Object> get props => [response];
}

class ExportLeadsError extends MyProfileState {
  final String error;

  ExportLeadsError({required this.error});

  @override
  List<Object> get props => [error];
}
