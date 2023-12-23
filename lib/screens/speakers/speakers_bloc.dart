import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pce/models/speakers/speakers_model.dart';
import 'package:pce/screens/agenda/agenda_repo.dart';


class SpeakersBloc extends Bloc<SpeakersEventBase, SpeakersState> {
  SpeakersBloc() : super(SpeakersEmpty()) {
    on<SpeakersEvent>(
          (event, emit) async {
        emit(SpeakersLoading());
        try {
          SpeakersModel response =
          await AgendaRepo.instance.getSpeakers(event.body);
          emit(SpeakersLoaded(response: response));
        } catch (e) {
          if (e is String) {
            emit(SpeakersError(error: e));
          } else {
            emit(SpeakersError(error: 'Unauthorized'));
          }
        }
      },
    );
  }
}

abstract class SpeakersEventBase extends Equatable {
  const SpeakersEventBase();
}

class SpeakersEvent extends SpeakersEventBase {
  Map<String, dynamic> body;

  SpeakersEvent({required this.body});

  @override
  List<Object> get props => [body];
}

abstract class SpeakersState extends Equatable {
  const SpeakersState();

  @override
  List<Object> get props => [];
}

class SpeakersEmpty extends SpeakersState {}

class SpeakersLoading extends SpeakersState {}

class SpeakersLoaded extends SpeakersState {
  final SpeakersModel response;

  const SpeakersLoaded({required this.response});

  @override
  List<Object> get props => [response];
}

class SpeakersError extends SpeakersState {
  final String error;

  SpeakersError({required this.error});

  @override
  List<Object> get props => [error];
}
