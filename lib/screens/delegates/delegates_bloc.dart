import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pce/screens/agenda/agenda_repo.dart';

import '../../models/delegates/delegates_responce_entity.dart';

class DelegatesBloc extends Bloc<DelegatesEventBase, DelegatesState> {
  DelegatesBloc() : super(DelegatesEmpty()) {
    on<DelegatesEvent>(
          (event, emit) async {
        emit(DelegatesLoading());
        try {
          DelegatesResponseEntity response =
          await AgendaRepo.instance.getDelegatesDetails(event.body);
          emit(DelegatesLoaded(response: response));
        } catch (e) {
          if (e is String) {
            emit(DelegatesError(error: e));
          } else {
            emit(DelegatesError(error: 'Unauthorized'));
          }
        }
      },
    );
  }
}

abstract class DelegatesEventBase extends Equatable {
  const DelegatesEventBase();
}

class DelegatesEvent extends DelegatesEventBase {
  Map<String, dynamic> body;

  DelegatesEvent({required this.body});

  @override
  List<Object> get props => [body];
}

abstract class DelegatesState extends Equatable {
  const DelegatesState();

  @override
  List<Object> get props => [];
}

class DelegatesEmpty extends DelegatesState {}

class DelegatesLoading extends DelegatesState {}

class DelegatesLoaded extends DelegatesState {
  final DelegatesResponseEntity response;

  const DelegatesLoaded({required this.response});

  @override
  List<Object> get props => [response];
}

class DelegatesError extends DelegatesState {
  final String error;

  DelegatesError({required this.error});

  @override
  List<Object> get props => [error];
}
