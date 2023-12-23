class CountriesModel {
  bool? status;
  List<Data>? data;

  CountriesModel({this.status, this.data});

  CountriesModel.fromJson(Map<String, dynamic> json) {
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
  String? zoneId;
  String? name;
  String? country3Code;
  String? country2Code;
  String? published;
  String? phoneAreaCode;

  Data(
      {this.id,
        this.zoneId,
        this.name,
        this.country3Code,
        this.country2Code,
        this.published,
        this.phoneAreaCode});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    zoneId = json['zone_id'];
    name = json['name'];
    country3Code = json['country_3_code'];
    country2Code = json['country_2_code'];
    published = json['published'];
    phoneAreaCode = json['phone_area_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['zone_id'] = this.zoneId;
    data['name'] = this.name;
    data['country_3_code'] = this.country3Code;
    data['country_2_code'] = this.country2Code;
    data['published'] = this.published;
    data['phone_area_code'] = this.phoneAreaCode;
    return data;
  }
}
