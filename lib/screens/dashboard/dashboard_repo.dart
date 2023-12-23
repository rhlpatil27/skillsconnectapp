
import 'dart:io';

import 'package:pce/models/agenda/agenda_response.dart';
import 'package:pce/models/agenda/filter/get_all_days.dart';
import 'package:pce/models/agenda/filter/get_all_zones.dart';
import 'package:pce/models/notification/is_notification_pending_response.dart';
import 'package:pce/models/user_events/update_details_model.dart';

import '../../models/delegates/delegates_responce_entity.dart';
import '../../models/partners/partners_categories.dart';
import '../../models/partners/partners_model.dart';
import '../../models/speakers/speakers_model.dart';
import '../../models/user_events/countries_model.dart';
import '../../network/api_provider.dart';

class DashboardRepo {
  DashboardRepo._privateConstructor();

  static final DashboardRepo instance = DashboardRepo._privateConstructor();

  Future<IsNotificationPendingResponse> getUnreadNotifications(Map<String, dynamic>? body) async {
    final response = await ApiProvider.instance.post("get_unread_notifications", body);
    return IsNotificationPendingResponse.fromJson(response);
  }

}
