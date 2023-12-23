class IsNotificationPendingResponse {
  bool? status;
  bool? response;

  IsNotificationPendingResponse({this.status, this.response});

  IsNotificationPendingResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    response = json['response'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['response'] = this.response;
    return data;
  }
}
