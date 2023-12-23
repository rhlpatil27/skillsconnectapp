
import 'package:pce/models/QrCode/QrCodeDetails.dart';

import '../../network/api_provider.dart';

class QrRepo {
  QrRepo._privateConstructor();

  static final QrRepo instance = QrRepo._privateConstructor();

  Future<QrCodeDetails> getQrUserDeatils(Map<String, dynamic>? body) async {
    final response = await ApiProvider.instance.post("get_qr_code_details", body);
    return QrCodeDetails.fromJson(response);
  }
}
