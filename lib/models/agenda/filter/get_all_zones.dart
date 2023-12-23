class GetAllZones {
  bool? status;
  List<Data>? data;

  GetAllZones({this.status, this.data});

  GetAllZones.fromJson(Map<String, dynamic> json) {
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
  String? zoneId;
  String? id;
  String? zoneName;
  String? abbreviation;

  Data({this.zoneId, this.id, this.zoneName, this.abbreviation});

  Data.fromJson(Map<String, dynamic> json) {
    zoneId = json['zone_id'];
    id = json['id'];
    zoneName = json['zone_name'];
    abbreviation = json['abbreviation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['zone_id'] = this.zoneId;
    data['id'] = this.id;
    data['zone_name'] = this.zoneName;
    data['abbreviation'] = this.abbreviation;
    return data;
  }
}
