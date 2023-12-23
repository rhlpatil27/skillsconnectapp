class GetAllDays {
  bool? status;
  List<Data>? data;

  GetAllDays({this.status, this.data});

  GetAllDays.fromJson(Map<String, dynamic> json) {
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

  @override
  String toString() {
    return 'GetAllDays{status: $status, data: $data}';
  }
}

class Data {
  String? id;
  String? dayName;
  String? date;
  String? location;

  Data({this.id, this.dayName, this.date, this.location});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dayName = json['day_name'];
    date = json['date'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['day_name'] = this.dayName;
    data['date'] = this.date;
    data['location'] = this.location;
    return data;
  }

  @override
  String toString() {
    return 'Data{id: $id, dayName: $dayName, date: $date, location: $location}';
  }
}
