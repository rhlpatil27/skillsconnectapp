
import 'dart:io';

import 'package:pce/models/agenda/agenda_response.dart';
import 'package:pce/models/agenda/filter/get_all_days.dart';
import 'package:pce/models/agenda/filter/get_all_zones.dart';
import 'package:pce/models/chat/get_chat_users_response.dart';
import 'package:pce/models/chat/get_user_chat_image_response.dart';
import 'package:pce/models/chat/get_user_messages_response.dart';
import 'package:pce/models/user_events/update_details_model.dart';

import '../../models/chat/delete_message_response.dart';
import '../../models/delegates/delegates_responce_entity.dart';
import '../../models/partners/partners_categories.dart';
import '../../models/partners/partners_model.dart';
import '../../models/speakers/speakers_model.dart';
import '../../models/user_events/countries_model.dart';
import '../../network/api_provider.dart';

class ChatUsersRepo {
  ChatUsersRepo._privateConstructor();

  static final ChatUsersRepo instance = ChatUsersRepo._privateConstructor();

  Future<GetChatUsersResponse> getAllChatUsers(Map<String, dynamic>? body) async {
    final response =
        await ApiProvider.instance.post("get_chat_users", body);
    return GetChatUsersResponse.fromJson(response);
  }
  Future<GetUserMessagesResponse> getUserMessages(Map<String, dynamic>? body) async {
    final response =
    await ApiProvider.instance.post("get_user_messages", body);
    return GetUserMessagesResponse.fromJson(response);
  }
  Future<DeleteMessageResponse> deleteMessage(Map<String, dynamic>? body) async {
    final response =
    await ApiProvider.instance.post("delete_chat", body);
    return DeleteMessageResponse.fromJson(response);
  }
  Future<UserChatImageSendResponse> uploadChatImage(File body,String userId) async {
    final response =
    await ApiProvider.instance.uploadImage("upload_attachment", body,userId);
    return UserChatImageSendResponse.fromJson(response);
  }
}
