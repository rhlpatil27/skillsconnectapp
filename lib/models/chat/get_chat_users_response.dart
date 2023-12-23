class GetChatUsersResponse {
  GetChatUsersResponse({
    required this.status,
    required this.data,
  });
  late final bool status;
  late final List<Data> data;

  GetChatUsersResponse.fromJson(Map<String, dynamic> json){
    status = json['status'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.chatId,
    required this.unreadCount,
  });
  late final String id;
  late final String chatId;
  late final String name;
  late final String imageUrl;
  String? unreadCount;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    chatId = json['chat_id'];
    unreadCount = json['unread_count'];
    name = json['name'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['chat_id'] = chatId;
    _data['name'] = name;
    _data['image_url'] = imageUrl;
    _data['unread_count'] = unreadCount;
    return _data;
  }
}