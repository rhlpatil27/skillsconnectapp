class PartnersModel {
  bool? status;
  List<Data>? data;

  PartnersModel({this.status, this.data});

  PartnersModel.fromJson(Map<String, dynamic> json) {
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
  String? partnerType;
  List<Partners>? partners;

  Data({this.partnerType, this.partners});

  Data.fromJson(Map<String, dynamic> json) {
    partnerType = json['partner_type'];
    if (json['partners'] != null) {
      partners = <Partners>[];
      json['partners'].forEach((v) {
        partners!.add(new Partners.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['partner_type'] = this.partnerType;
    if (this.partners != null) {
      data['partners'] = this.partners!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Partners {
  String? logo;
  String? company;

  Partners({this.logo, this.company});

  Partners.fromJson(Map<String, dynamic> json) {
    logo = json['logo'];
    company = json['company'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['logo'] = this.logo;
    data['company'] = this.company;
    return data;
  }
}
