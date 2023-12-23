class QrCodeDetails {
  bool? status;
  Data? data;

  QrCodeDetails({this.status, this.data});

  QrCodeDetails.fromJson(Map<String, dynamic> json) {
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
  String? eventId;
  String? id;
  String? fromUserId;
  String? siteId;
  String? userId;
  String? title;
  String? firstName;
  String? lastName;
  String? email;
  String? emailVerified;
  String? emailKey;
  String? phone;
  String? officePhone;
  String? password;
  String? address;
  String? country;
  String? jobTitle;
  String? industry;
  String? experienceLevel;
  String? company;
  String? alternativeEmail;
  String? registrationCategory;
  String? memberSitOnAnotherTable;
  String? shareDetails;
  String? subscription;
  String? termsAndConditions;
  String? bio;
  String? headshot;
  String? logo;
  String? brochure;
  String? flyer;
  String? caseStudy;
  String? videoLink;
  String? websiteLink;
  String? linkedinLink;
  String? dietaryRequirements;
  String? dietaryRequirementsOrAllergies;
  String? sync;
  String? createdOn;
  String? createdBy;
  String? modifiedOn;
  String? modifiedBy;

  Data(
      {this.eventId,
        this.id,
        this.fromUserId,
        this.siteId,
        this.userId,
        this.title,
        this.firstName,
        this.lastName,
        this.email,
        this.emailVerified,
        this.emailKey,
        this.phone,
        this.officePhone,
        this.password,
        this.address,
        this.country,
        this.jobTitle,
        this.industry,
        this.experienceLevel,
        this.company,
        this.alternativeEmail,
        this.registrationCategory,
        this.memberSitOnAnotherTable,
        this.shareDetails,
        this.subscription,
        this.termsAndConditions,
        this.bio,
        this.headshot,
        this.logo,
        this.brochure,
        this.flyer,
        this.caseStudy,
        this.videoLink,
        this.websiteLink,
        this.linkedinLink,
        this.dietaryRequirements,
        this.dietaryRequirementsOrAllergies,
        this.sync,
        this.createdOn,
        this.createdBy,
        this.modifiedOn,
        this.modifiedBy});

  Data.fromJson(Map<String, dynamic> json) {
    eventId = json['event_id'];
    id = json['id'];
    fromUserId = json['id'];
    siteId = json['site_id'];
    userId = json['user_id'];
    title = json['title'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    emailVerified = json['email_verified'];
    emailKey = json['email_key'];
    phone = json['phone'];
    officePhone = json['office_phone'];
    password = json['password'];
    address = json['address'];
    country = json['country_name'];
    jobTitle = json['job_title'];
    industry = json['industry'];
    experienceLevel = json['experience_level'];
    company = json['company'];
    alternativeEmail = json['alternative_email'];
    registrationCategory = json['registration_category'];
    memberSitOnAnotherTable = json['member_sit_on_another_table'];
    shareDetails = json['share_details'];
    subscription = json['subscription'];
    termsAndConditions = json['terms_and_conditions'];
    bio = json['bio'];
    headshot = json['headshot'];
    logo = json['logo'];
    brochure = json['brochure'];
    flyer = json['flyer'];
    caseStudy = json['case_study'];
    videoLink = json['video_link'];
    websiteLink = json['website_link'];
    linkedinLink = json['linkedin_link'];
    dietaryRequirements = json['dietary_requirements'];
    dietaryRequirementsOrAllergies = json['dietary_requirements_or_allergies'];
    sync = json['sync'];
    createdOn = json['created_on'];
    createdBy = json['created_by'];
    modifiedOn = json['modified_on'];
    modifiedBy = json['modified_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_id'] = this.eventId;
    data['id'] = this.id;
    data['id'] = this.fromUserId;
    data['site_id'] = this.siteId;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['email_verified'] = this.emailVerified;
    data['email_key'] = this.emailKey;
    data['phone'] = this.phone;
    data['office_phone'] = this.officePhone;
    data['password'] = this.password;
    data['address'] = this.address;
    data['country_name'] = this.country;
    data['job_title'] = this.jobTitle;
    data['industry'] = this.industry;
    data['experience_level'] = this.experienceLevel;
    data['company'] = this.company;
    data['alternative_email'] = this.alternativeEmail;
    data['registration_category'] = this.registrationCategory;
    data['member_sit_on_another_table'] = this.memberSitOnAnotherTable;
    data['share_details'] = this.shareDetails;
    data['subscription'] = this.subscription;
    data['terms_and_conditions'] = this.termsAndConditions;
    data['bio'] = this.bio;
    data['headshot'] = this.headshot;
    data['logo'] = this.logo;
    data['brochure'] = this.brochure;
    data['flyer'] = this.flyer;
    data['case_study'] = this.caseStudy;
    data['video_link'] = this.videoLink;
    data['website_link'] = this.websiteLink;
    data['linkedin_link'] = this.linkedinLink;
    data['dietary_requirements'] = this.dietaryRequirements;
    data['dietary_requirements_or_allergies'] =
        this.dietaryRequirementsOrAllergies;
    data['sync'] = this.sync;
    data['created_on'] = this.createdOn;
    data['created_by'] = this.createdBy;
    data['modified_on'] = this.modifiedOn;
    data['modified_by'] = this.modifiedBy;
    return data;
  }

  @override
  String toString() {
    return 'Data{eventId: $eventId, id: $id, siteId: $siteId, userId: $userId, title: $title, firstName: $firstName, lastName: $lastName, email: $email, emailVerified: $emailVerified, emailKey: $emailKey, phone: $phone, officePhone: $officePhone, password: $password, address: $address, country: $country, jobTitle: $jobTitle, industry: $industry, experienceLevel: $experienceLevel, company: $company, alternativeEmail: $alternativeEmail, registrationCategory: $registrationCategory, memberSitOnAnotherTable: $memberSitOnAnotherTable, shareDetails: $shareDetails, subscription: $subscription, termsAndConditions: $termsAndConditions, bio: $bio, headshot: $headshot, logo: $logo, brochure: $brochure, flyer: $flyer, caseStudy: $caseStudy, videoLink: $videoLink, websiteLink: $websiteLink, linkedinLink: $linkedinLink, dietaryRequirements: $dietaryRequirements, dietaryRequirementsOrAllergies: $dietaryRequirementsOrAllergies, sync: $sync, createdOn: $createdOn, createdBy: $createdBy, modifiedOn: $modifiedOn, modifiedBy: $modifiedBy}';
  }
}
