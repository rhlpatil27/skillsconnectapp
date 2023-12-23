class SpeakersModel {
  bool? status;
  List<Data>? data;

  SpeakersModel({this.status, this.data});

  SpeakersModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? firstName;
  String? lastName;
  String? name;
  String? jobTitle;
  String? company;
  String? headshot;
  String? title;
  String? linkedinLink;
  String? country;


  Data(
      {this.id,
        this.firstName,
        this.lastName,
        this.name,
        this.title,
        this.linkedinLink,
        this.jobTitle,
        this.company,
        this.headshot,
        this.country});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    name = json['name'];
    title = json['title'];
    linkedinLink = json['linkedin_link'];
    jobTitle = json['job_title'];
    company = json['company'];
    headshot = json['headshot'];
    country = json['country_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['name'] = this.name;
    data['title'] = this.title;
    data['linkedin_link'] = this.linkedinLink;
    data['job_title'] = this.jobTitle;
    data['company'] = this.company;
    data['headshot'] = this.headshot;
    data['country_name'] = this.country;
    return data;
  }
}
