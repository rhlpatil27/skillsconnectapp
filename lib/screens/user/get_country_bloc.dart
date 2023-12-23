import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pce/screens/agenda/agenda_repo.dart';

import '../../models/user_events/countries_model.dart';
import '../../models/user_events/update_details_model.dart';


class CountryBloc extends Bloc<CountryEventBase, CountryState> {
  CountriesModel responseCountry = CountriesModel();

  CountryBloc() : super(CountryEmpty()) {
    on<CountryEvent>(
          (event, emit) async {
        emit(CountryLoading());
        try {
        responseCountry =
          await AgendaRepo.instance.getCountryDetails();
          emit(CountryLoaded(response: responseCountry));
        } catch (e) {
          if (e is String) {
            emit(CountryError(error: e));
          } else {
            emit(CountryError(error: 'Unauthorized'));
          }
        }
      },
    );



    on<UpdateProfileEvent>(
          (event, emit) async {
        emit(UpdateProfileLoading());
        try {
          UpdateDetailsModel response =
          await AgendaRepo.instance.updateUserDetails(event.body);
          emit(UpdateProfileLoaded(response: response));
        } catch (e) {
          if (e is String) {
            emit(UpdateProfileError(error: e));
          } else {
            emit(UpdateProfileError(error: 'Unauthorized'));
          }
        }
      },
    );

    on<UpdatePhotoEvent>(
          (event, emit) async {
        emit(UpdateProfileLoading());
        try {
          UpdateDetailsModel response =
          await AgendaRepo.instance.updatePhoto(event.body,event.userId!);
          emit(UpdateProfileLoaded(response: response));
          // emit(CountryLoaded(response: responseCountry));
        } catch (e) {
          if (e is String) {
            emit(UpdateProfileError(error: e));
          } else {
            emit(UpdateProfileError(error: 'Unauthorized'));
          }
        }
      },
    );

  }
}


abstract class CountryEventBase extends Equatable {
  const CountryEventBase();
}

class CountryEvent extends CountryEventBase {

  CountryEvent();

  @override
  List<Object> get props => [];
}

abstract class CountryState extends Equatable {
  const CountryState();

  @override
  List<Object> get props => [];
}

class CountryEmpty extends CountryState {}

class CountryLoading extends CountryState {}

class CountryLoaded extends CountryState {
  final CountriesModel response;

  const CountryLoaded({required this.response});

  @override
  List<Object> get props => [response];
}

class CountryError extends CountryState {
  final String error;

  CountryError({required this.error});

  @override
  List<Object> get props => [error];
}

/// UPDATE PROFILE

class UpdateProfileEvent extends CountryEventBase {
  Map<String, dynamic> body;

  UpdateProfileEvent({required this.body});

  @override
  List<Object> get props => [body];
}

class UpdateProfileLoading extends CountryState {}

class UpdateProfileLoaded extends CountryState {
  final UpdateDetailsModel response;

  const UpdateProfileLoaded({required this.response});

  @override
  List<Object> get props => [response];
}

class UpdateProfileError extends CountryState {
  final String error;

  UpdateProfileError({required this.error});

  @override
  List<Object> get props => [error];
}
 ///  UPLOAD PHOTO

class UpdatePhotoEvent extends CountryEventBase {
  File body;
  String? userId;

  UpdatePhotoEvent({required this.body,this.userId});

  @override
  List<Object> get props => [body];
}

class UpdatePhotoLoading extends CountryState {}

class UpdatePhotoLoaded extends CountryState {
  final UpdateDetailsModel response;

  const UpdatePhotoLoaded({required this.response});

  @override
  List<Object> get props => [response];
}

class UpdatePhotoError extends CountryState {
  final String error;

  UpdatePhotoError({required this.error});

  @override
  List<Object> get props => [error];
}
