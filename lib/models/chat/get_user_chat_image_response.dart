class UserChatImageSendResponse {
  bool? status;
  String? msg;
  String? url;

  UserChatImageSendResponse({this.status, this.msg, this.url});

  UserChatImageSendResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    url = json['attachment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    data['attachment'] = this.url;
    return data;
  }

  @override
  String toString() {
    return 'DeleteMessageResponse{status: $status, msg: $msg, attachment: $url}';
  }
}
