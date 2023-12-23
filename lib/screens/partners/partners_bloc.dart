import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pce/models/partners/partners_model.dart';
import 'package:pce/screens/agenda/agenda_repo.dart';

import '../../models/partners/partners_categories.dart';


class PartnersBloc extends Bloc<PartnersEventBase, PartnersState> {
  PartnersBloc() : super(PartnersEmpty()) {
    on<PartnersEvent>(
          (event, emit) async {
        emit(PartnersLoading());
        try {
          PartnersModel response =
          await AgendaRepo.instance.getPartners(event.body);
          emit(PartnersLoaded(response: response));
        } catch (e) {
          if (e is String) {
            emit(PartnersError(error: e));
          } else {
            emit(PartnersError(error: 'Unauthorized'));
          }
        }
      },
    );

    on<PartnersCategoryEvent>(
          (event, emit) async {
        emit(PartnersCategoryLoading());
        try {
          PartnersCategoriesModel response =
          await AgendaRepo.instance.getPartnersCategory(event.body);
          emit(PartnersCategoryLoaded(response: response));
        } catch (e) {
          if (e is String) {
            emit(PartnersCategoryError(error: e));
          } else {
            emit(PartnersCategoryError(error: 'Unauthorized'));
          }
        }
      },
    );
  }
}

abstract class PartnersEventBase extends Equatable {
  const PartnersEventBase();
}

class PartnersEvent extends PartnersEventBase {
  Map<String, dynamic> body;

  PartnersEvent({required this.body});

  @override
  List<Object> get props => [body];
}

abstract class PartnersState extends Equatable {
  const PartnersState();

  @override
  List<Object> get props => [];
}

class PartnersEmpty extends PartnersState {}

class PartnersLoading extends PartnersState {}

class PartnersLoaded extends PartnersState {
  final PartnersModel response;

  const PartnersLoaded({required this.response});

  @override
  List<Object> get props => [response];
}

class PartnersError extends PartnersState {
  final String error;

  PartnersError({required this.error});

  @override
  List<Object> get props => [error];
}
 /// CATEGORIES OF PARTNERS

abstract class PartnersCategoryEventBase extends Equatable {
  const PartnersCategoryEventBase();
}

class PartnersCategoryEvent extends PartnersEventBase {
  Map<String, dynamic> body;

  PartnersCategoryEvent({required this.body});

  @override
  List<Object> get props => [body];
}

class PartnersCategoryEmpty extends PartnersState {}

class PartnersCategoryLoading extends PartnersState {}

class PartnersCategoryLoaded extends PartnersState {
  final PartnersCategoriesModel response;

  const PartnersCategoryLoaded({required this.response});

  @override
  List<Object> get props => [response];
}

class PartnersCategoryError extends PartnersState {
  final String error;

  PartnersCategoryError({required this.error});

  @override
  List<Object> get props => [error];
}