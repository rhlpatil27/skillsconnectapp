import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pce/models/agenda/filter/get_all_days.dart';
import 'package:pce/models/agenda/filter/get_all_zones.dart';
import 'package:pce/models/notification/is_notification_pending_response.dart';
import 'package:pce/network/api_provider.dart';
import 'package:pce/screens/agenda/agenda_repo.dart';
import 'package:pce/screens/dashboard/dashboard_repo.dart';

import '../../models/agenda/agenda_response.dart';

class DashboardBloc extends Bloc<DashboardEventBase, DashboardState> {
  DashboardBloc() : super(DashboardEmpty()) {
    on<IsNotiStatusEvent>(
      (event, emit) async {
        emit(DashboardLoading());
        try {
          IsNotificationPendingResponse response =
              await DashboardRepo.instance.getUnreadNotifications(event.body);
          if(response.status == true){
            ApiProvider.instance.setShowBadge(response.response);
            emit(DashboardNotiStatusFetched(response: response));
          }else{
            emit(DashboardError(error: 'Something went wrong!'));
          }
        } catch (e) {
          if (e is String) {
            emit(DashboardError(error: e));
          } else {
            emit(DashboardError(error: 'Unauthorized'));
          }
        }
      },
    );
  }
}

abstract class DashboardEventBase extends Equatable {
  const DashboardEventBase();
}

class IsNotiStatusEvent extends DashboardEventBase {
  Map<String, dynamic> body;

  IsNotiStatusEvent({required this.body});

  @override
  List<Object> get props => [body];
}


abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardEmpty extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardNotiStatusFetched extends DashboardState {
  final IsNotificationPendingResponse response;

  const DashboardNotiStatusFetched({required this.response});

  @override
  List<Object> get props => [response];
}

class DashboardError extends DashboardState {
  final String error;

  DashboardError({required this.error});

  @override
  List<Object> get props => [error];
}

