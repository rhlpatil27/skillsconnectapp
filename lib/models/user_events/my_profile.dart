class MyProfileModel {
  bool? status;
  Data? data;

  MyProfileModel({this.status, this.data});

  MyProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? firstName;
  String? lastName;
  String? jobTitle;
  String? company;
  String? country;
  String? phone;
  String? email;
  String? headshot;
  String? linkedinLink;

  Data(
      {this.id,
        this.firstName,
        this.lastName,
        this.jobTitle,
        this.company,
        this.country,
        this.phone,
        this.email,
        this.headshot,
        this.linkedinLink});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    jobTitle = json['job_title'];
    company = json['company'];
    country = json['country_name'];
    phone = json['phone'];
    email = json['email'];
    headshot = json['headshot'];

    linkedinLink = json['linkedin_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['job_title'] = this.jobTitle;
    data['company'] = this.company;
    data['country_name'] = this.country;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['headshot'] = this.headshot;
    data['linkedin_link'] = this.linkedinLink;
    return data;
  }
}
