class DeleteMessageResponse {
  bool? status;
  String? msg;

  DeleteMessageResponse({this.status, this.msg});

  DeleteMessageResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    return data;
  }

  @override
  String toString() {
    return 'DeleteMessageResponse{status: $status, msg: $msg}';
  }
}
