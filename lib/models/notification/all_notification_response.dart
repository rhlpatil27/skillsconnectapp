class AllNotificationResponse {
  bool? status;
  String? msg;
  List<Data>? data;

  AllNotificationResponse({this.status, this.msg, this.data});

  AllNotificationResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
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
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? fromUserId;
  String? toUserId;
  String? message;
  String? dateTime;
  String? id;
  String? title;
  String? firstName;
  String? lastName;
  String? name;
  String? jobTitle;
  String? company;
  String? linkedinLink;
  String? headshot;
  String? country;

  Data(
      {this.fromUserId,
        this.toUserId,
        this.message,
        this.dateTime,
        this.id,
        this.title,
        this.firstName,
        this.lastName,
        this.name,
        this.jobTitle,
        this.company,
        this.linkedinLink,
        this.headshot,
        this.country});

  Data.fromJson(Map<String, dynamic> json) {
    fromUserId = json['from_user_id'];
    toUserId = json['to_user_id'];
    message = json['message'];
    dateTime = json['date_time'];
    id = json['id'];
    title = json['title'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    name = json['name'];
    jobTitle = json['job_title'];
    company = json['company'];
    linkedinLink = json['linkedin_link'];
    headshot = json['headshot'];
    country = json['country_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['from_user_id'] = this.fromUserId;
    data['to_user_id'] = this.toUserId;
    data['message'] = this.message;
    data['date_time'] = this.dateTime;
    data['id'] = this.id;
    data['title'] = this.title;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['name'] = this.name;
    data['job_title'] = this.jobTitle;
    data['company'] = this.company;
    data['linkedin_link'] = this.linkedinLink;
    data['headshot'] = this.headshot;
    data['country_name'] = this.country;
    return data;
  }

  @override
  String toString() {
    return 'Data{fromUserId: $fromUserId, toUserId: $toUserId, message: $message, dateTime: $dateTime, id: $id, title: $title, firstName: $firstName, lastName: $lastName, name: $name, jobTitle: $jobTitle, company: $company, linkedinLink: $linkedinLink, headshot: $headshot, countryName: $country}';
  }
}
