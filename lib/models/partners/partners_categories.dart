class PartnersCategoriesModel {
  bool? status;
  List<Data>? data;

  PartnersCategoriesModel({this.status, this.data});

  PartnersCategoriesModel.fromJson(Map<String, dynamic> json) {
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
  String? eventId;
  String? categoryName;
  String? partnerCategorySlug;
  String? createdOn;
  String? createdBy;
  String? modifiedBy;
  String? modifiedOn;

  Data(
      {this.id,
        this.eventId,
        this.categoryName,
        this.partnerCategorySlug,
        this.createdOn,
        this.createdBy,
        this.modifiedBy,
        this.modifiedOn});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventId = json['event_id'];
    categoryName = json['category_name'];
    partnerCategorySlug = json['partner_category_slug'];
    createdOn = json['created_on'];
    createdBy = json['created_by'];
    modifiedBy = json['modified_by'];
    modifiedOn = json['modified_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['event_id'] = this.eventId;
    data['category_name'] = this.categoryName;
    data['partner_category_slug'] = this.partnerCategorySlug;
    data['created_on'] = this.createdOn;
    data['created_by'] = this.createdBy;
    data['modified_by'] = this.modifiedBy;
    data['modified_on'] = this.modifiedOn;
    return data;
  }
}
