import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pce/models/QrCode/QrCodeDetails.dart';
import 'package:pce/models/user_events/update_details_model.dart';
import 'package:pce/models/user_events/user_events.dart';
import 'package:pce/network/api_provider.dart';
import 'package:pce/screens/login/login_repo.dart';
import 'package:pce/screens/qr/qr_repo.dart';

import '../../models/login/LoginResponse.dart';

class QrBloc extends Bloc<QrEventBase, QrState> {
  QrBloc() : super(QrEmpty()) {
    on<QrEvent>(
      (event, emit) async {
        emit(QrLoading());
        try {
           QrCodeDetails response = await QrRepo.instance.getQrUserDeatils(event.body);
          if (response.status == true){
            if(response.data != null){
              emit(QrLoaded(response: response));
            }else{
              emit(QrFailed(error: "Something went wrong! Please try again"));
            }
          } else {
            emit(QrFailed(error: "Something went wrong!"));
          }
        } catch (e) {
          if (e is String) {
            emit(QrFailed(error: e));
          } else {
            emit(QrFailed(error: 'Unauthorized'));
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

abstract class QrEventBase extends Equatable {
  const QrEventBase();
}

class QrEvent extends QrEventBase {
  Map<String, dynamic> body;

  QrEvent({required this.body}) : assert(body != null);

  @override
  List<Object> get props => [body];
}

abstract class QrState extends Equatable {
  const QrState();

  @override
  List<Object> get props => [];
}

class QrEmpty extends QrState {}

class QrLoading extends QrState {}

class QrLoaded extends QrState {
  final QrCodeDetails response;

  const QrLoaded({required this.response}) : assert(response != null);

  @override
  List<Object> get props => [response];
}

class QrFailed extends QrState {
  final String error;

  QrFailed({required this.error}) : assert(error != null);

  @override
  List<Object> get props => [error];
}

/// EXPORT LEADS

class ExportLeadsEvent extends QrEventBase {
  Map<String, dynamic> body;

  ExportLeadsEvent({required this.body});

  @override
  List<Object> get props => [body];
}

class ExportLeadsEmpty extends QrState {}

class ExportLeadsLoading extends QrState {}

class ExportLeadsLoaded extends QrState {
  final UpdateDetailsModel response;

  const ExportLeadsLoaded({required this.response});

  @override
  List<Object> get props => [response];
}

class ExportLeadsError extends QrState {
  final String error;

  ExportLeadsError({required this.error});

  @override
  List<Object> get props => [error];
}
