class DelegatesResponseEntity {
  bool? status;
  List<Data>? data;

  DelegatesResponseEntity({this.status, this.data});

  DelegatesResponseEntity.fromJson(Map<String, dynamic> json) {
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
  String? eventId;
  String? id;
  String? fromUserId;
  String? siteId;
  String? userId;
  String? name;
  String? title;
  String? firstName;
  String? lastName;
  String? email;
  String? emailVerified;
  String? phone;
  String? password;
  String? address;
  String? country;
  String? jobTitle;
  String? industry;
  String? experienceLevel;
  String? company;
  String? registrationCategory;
  String? memberSitOnAnotherTable;
  String? shareDetails;
  String? subscription;
  String? termsAndConditions;
  String? headshot;
  String? dietaryRequirements;
  String? dietaryRequirementsOrAllergies;
  String? sync;
  String? createdOn;
  String? modifiedOn;
  String? modifiedBy;
  String? linkedinLink;

  Data(
      {this.eventId,
      this.id,
      this.fromUserId,
      this.siteId,
      this.userId,
      this.name,
      this.title,
      this.firstName,
      this.lastName,
      this.email,
      this.emailVerified,
      this.phone,
      this.password,
      this.address,
      this.country,
      this.jobTitle,
      this.industry,
      this.experienceLevel,
      this.company,
      this.registrationCategory,
      this.memberSitOnAnotherTable,
      this.shareDetails,
      this.subscription,
      this.termsAndConditions,
      this.headshot,
      this.dietaryRequirements,
      this.dietaryRequirementsOrAllergies,
      this.sync,
      this.createdOn,
      this.modifiedOn,
      this.modifiedBy,
      this.linkedinLink});

  Data.fromJson(Map<String, dynamic> json) {
    eventId = json['event_id'];
    id = json['id'];
    fromUserId = json['id'];
    siteId = json['site_id'];
    name = json['name'];
    userId = json['user_id'];
    title = json['title'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    emailVerified = json['email_verified'];
    phone = json['phone'];
    password = json['password'];
    address = json['address'];
    country = json['country_name'];
    jobTitle = json['job_title'];
    industry = json['industry'];
    experienceLevel = json['experience_level'];
    company = json['company'];
    registrationCategory = json['registration_category'];
    memberSitOnAnotherTable = json['member_sit_on_another_table'];
    shareDetails = json['share_details'];
    subscription = json['subscription'];
    termsAndConditions = json['terms_and_conditions'];
    headshot = json['headshot'];
    dietaryRequirements = json['dietary_requirements'];
    dietaryRequirementsOrAllergies = json['dietary_requirements_or_allergies'];
    sync = json['sync'];
    createdOn = json['created_on'];
    modifiedOn = json['modified_on'];
    modifiedBy = json['modified_by'];
    linkedinLink = json['linkedin_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_id'] = this.eventId;
    data['id'] = this.id;
    data['id'] = this.fromUserId;
    data['site_id'] = this.siteId;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['title'] = this.title;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['email_verified'] = this.emailVerified;
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['address'] = this.address;
    data['country'] = this.country;
    data['job_title'] = this.jobTitle;
    data['industry'] = this.industry;
    data['experience_level'] = this.experienceLevel;
    data['company'] = this.company;
    data['registration_category'] = this.registrationCategory;
    data['member_sit_on_another_table'] = this.memberSitOnAnotherTable;
    data['share_details'] = this.shareDetails;
    data['subscription'] = this.subscription;
    data['terms_and_conditions'] = this.termsAndConditions;
    data['headshot'] = this.headshot;
    data['dietary_requirements'] = this.dietaryRequirements;
    data['dietary_requirements_or_allergies'] =
        this.dietaryRequirementsOrAllergies;
    data['sync'] = this.sync;
    data['created_on'] = this.createdOn;
    data['modified_on'] = this.modifiedOn;
    data['modified_by'] = this.modifiedBy;
    data['linkedin_link'] = this.linkedinLink;
    return data;
  }
}
