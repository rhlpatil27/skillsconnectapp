import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pce/models/agenda/filter/get_all_days.dart';
import 'package:pce/models/agenda/filter/get_all_zones.dart';
import 'package:pce/screens/agenda/agenda_repo.dart';

import '../../models/agenda/agenda_response.dart';

class AgendaBloc extends Bloc<AgendaEventBase, AgendaState> {
  AgendaBloc() : super(AgendaEmpty()) {
    on<AgendaEvent>(
      (event, emit) async {
        emit(AgendaLoading());
        try {
          AgendaResponse response =
              await AgendaRepo.instance.getAgendaDetails(event.body);
          if(response.status == true){
            emit(AgendaLoaded(response: response));
          }else{
            emit(AgendaError(error: 'Something went wrong!'));
          }
        } catch (e) {
          if (e is String) {
            emit(AgendaError(error: e));
          } else {
            emit(AgendaError(error: 'Unauthorized'));
          }
        }
      },
    );
    on<FetchDaysEvent>(
          (event, emit) async {
       emit(AllDaysLoading());
        try {
          GetAllDays response =
          await AgendaRepo.instance.getAllDays(event.body);
          if(response.status == true){
            emit(AllDaysFetched(response: response));
          }else{
            emit(AllDaysFetchError(error: 'Unauthorized'));
          }
        } catch (e) {
          if (e is String) {
            emit(AllDaysFetchError(error: e));
          } else {
            emit(AllDaysFetchError(error: 'Unauthorized'));
          }
        }
      },
    );
    on<FetchZonesEvent>(
          (event, emit) async {
        emit(AllZonesLoading());
        try {
          GetAllZones response =
          await AgendaRepo.instance.getAllZones(event.body);
          if(response.status == true){
            emit(AllZonesFetched(response: response));
          }else{
            emit(AllZonesFetchError(error: 'Unauthorized'));
          }
        } catch (e) {
          if (e is String) {
            emit(AllZonesFetchError(error: e));
          } else {
            emit(AllZonesFetchError(error: 'Unauthorized'));
          }
        }
      },
    );

  }
}

abstract class AgendaEventBase extends Equatable {
  const AgendaEventBase();
}

class AgendaEvent extends AgendaEventBase {
  Map<String, dynamic> body;

  AgendaEvent({required this.body});

  @override
  List<Object> get props => [body];
}

class FetchDaysEvent extends AgendaEventBase {
  Map<String, dynamic> body;

  FetchDaysEvent({required this.body});

  @override
  List<Object> get props => [body];
}

class FetchZonesEvent extends AgendaEventBase {
  Map<String, dynamic> body;

  FetchZonesEvent({required this.body});

  @override
  List<Object> get props => [body];
}

abstract class AgendaState extends Equatable {
  const AgendaState();

  @override
  List<Object> get props => [];
}

class AgendaEmpty extends AgendaState {}

class AgendaLoading extends AgendaState {}

class AgendaLoaded extends AgendaState {
  final AgendaResponse response;

  const AgendaLoaded({required this.response});

  @override
  List<Object> get props => [response];
}

class AgendaError extends AgendaState {
  final String error;

  AgendaError({required this.error});

  @override
  List<Object> get props => [error];
}

class AllDaysFetched extends AgendaState {
  final GetAllDays response;

  const AllDaysFetched({required this.response});

  @override
  List<Object> get props => [response];
}

class AllDaysFetchError extends AgendaState {
  final String error;

  AllDaysFetchError({required this.error});

  @override
  List<Object> get props => [error];
}
class AllDaysLoading extends AgendaState {}

class AllZonesFetched extends AgendaState {
  final GetAllZones response;

  const AllZonesFetched({required this.response});

  @override
  List<Object> get props => [response];
}

class AllZonesFetchError extends AgendaState {
  final String error;

  AllZonesFetchError({required this.error});

  @override
  List<Object> get props => [error];
}

class AllZonesLoading extends AgendaState {}
