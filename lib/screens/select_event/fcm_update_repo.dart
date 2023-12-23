
import 'package:pce/models/QrCode/QrCodeDetails.dart';
import 'package:pce/models/fcm_key_update/fcm_key_update.dart';

import '../../network/api_provider.dart';

class FcmKeyUpdateRepo {
  FcmKeyUpdateRepo._privateConstructor();

  static final FcmKeyUpdateRepo instance = FcmKeyUpdateRepo._privateConstructor();

  Future<FcmKeyUpdate> updateFcmToken(Map<String, dynamic>? body) async {
    final response = await ApiProvider.instance.post("update_fcm_token", body);
    return FcmKeyUpdate.fromJson(response);
  }
}
