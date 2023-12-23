/// status : true
/// data : {"user_id":"154","first_name":"Mahesh","last_name":"Ghadage","email":"mahesh.ghadage@conv.in","phone":"","registration_category":"Partner"}
/// msg : "Logged in successfully"

class LoginResponse {
  LoginResponse({
      bool? status, 
      Data? data, 
      String? msg}){
    _status = status;
    _data = data;
    _msg = msg;
}

  LoginResponse.fromJson(dynamic json) {
    _status = json['status'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _msg = json['msg'];
  }
  bool? _status;
  Data? _data;
  String? _msg;
LoginResponse copyWith({  bool? status,
  Data? data,
  String? msg,
}) => LoginResponse(  status: status ?? _status,
  data: data ?? _data,
  msg: msg ?? _msg,
);
  bool? get status => _status;
  Data? get data => _data;
  String? get msg => _msg;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    map['msg'] = _msg;
    return map;
  }

}

/// user_id : "154"
/// first_name : "Mahesh"
/// last_name : "Ghadage"
/// email : "mahesh.ghadage@conv.in"
/// phone : ""
/// registration_category : "Partner"

class Data {
  Data({
      String? userId, 
      String? firstName, 
      String? lastName, 
      String? email, 
      String? phone, 
      String? imageUrl,
      String? registrationCategory,}){
    _userId = userId;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _phone = phone;
    _imageUrl = imageUrl;
    _registrationCategory = registrationCategory;
}

  Data.fromJson(dynamic json) {
    _userId = json['user_id'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _email = json['email'];
    _phone = json['phone'];
    _imageUrl = json['image_url'];
    _registrationCategory = json['registration_category'];
  }
  String? _userId;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _phone;
  String? _imageUrl;
  String? _registrationCategory;
Data copyWith({  String? userId,
  String? firstName,
  String? lastName,
  String? email,
  String? phone,
  String? imageUrl,
  String? registrationCategory,
}) => Data(  userId: userId ?? _userId,
  firstName: firstName ?? _firstName,
  lastName: lastName ?? _lastName,
  email: email ?? _email,
  phone: phone ?? _phone,
  imageUrl: phone ?? _imageUrl,
  registrationCategory: registrationCategory ?? _registrationCategory,
);
  String? get userId => _userId;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get phone => _phone;
  String? get imageUrl => _imageUrl;
  String? get registrationCategory => _registrationCategory;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = _userId;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['email'] = _email;
    map['phone'] = _phone;
    map['image_url'] = _imageUrl;
    map['registration_category'] = _registrationCategory;
    return map;
  }

}