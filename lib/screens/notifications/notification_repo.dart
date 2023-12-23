
import 'package:pce/models/agenda/agenda_response.dart';
import 'package:pce/models/notification/all_notification_response.dart';

import '../../network/api_provider.dart';

class AllNotificationRepo {
  AllNotificationRepo._privateConstructor();

  static final AllNotificationRepo instance = AllNotificationRepo._privateConstructor();

  Future<AllNotificationResponse> getAllNotifications(Map<String, dynamic>? body) async {
    final response =
        await ApiProvider.instance.post("get_all_notifications", body);
    return AllNotificationResponse.fromJson(response);
  }
}
