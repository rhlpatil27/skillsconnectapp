
import 'package:pce/models/QrCode/QrCodeDetails.dart';
import 'package:pce/models/send_msg/send_msg.dart';
import 'package:pce/network/api_provider.dart';

class SendMsgRepo {
  SendMsgRepo._privateConstructor();

  static final SendMsgRepo instance = SendMsgRepo._privateConstructor();

  Future<SendNotification> addNote(Map<String, dynamic>? body) async {
    final response = await ApiProvider.instance.post("add_note", body);
    return SendNotification.fromJson(response);
  }

  Future<SendNotification> addMessage(Map<String, dynamic>? body) async {
    final response = await ApiProvider.instance.post("add_notification", body);
    return SendNotification.fromJson(response);
  }
}
