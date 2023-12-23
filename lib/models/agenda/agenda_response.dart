class AgendaResponse {
  bool? status;
  List<Data>? data;

  AgendaResponse({this.status, this.data});

  AgendaResponse.fromJson(Map<String, dynamic> json) {
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
  String? dayName;
  String? date;
  String? zoneName;
  String? abbreviation;
  List<Sessions>? sessions;

  Data(
      {this.dayName,
        this.date,
        this.zoneName,
        this.abbreviation,
        this.sessions});

  Data.fromJson(Map<String, dynamic> json) {
    dayName = json['day_name'];
    date = json['date'];
    zoneName = json['zone_name'];
    abbreviation = json['abbreviation'];
    if (json['sessions'] != null) {
      sessions = <Sessions>[];
      json['sessions'].forEach((v) {
        sessions!.add(new Sessions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day_name'] = this.dayName;
    data['date'] = this.date;
    data['zone_name'] = this.zoneName;
    data['abbreviation'] = this.abbreviation;
    if (this.sessions != null) {
      data['sessions'] = this.sessions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sessions {
  String? topic;
  String? description;
  String? fromTime;
  String? toTime;
  String? isBreak;
  List<Speakers>? speakers;

  Sessions(
      {this.topic,
        this.description,
        this.fromTime,
        this.toTime,
        this.isBreak,
        this.speakers});

  Sessions.fromJson(Map<String, dynamic> json) {
    topic = json['topic'];
    description = json['description'];
    fromTime = json['from_time'];
    toTime = json['to_time'];
    isBreak = json['is_break'];
    if (json['speakers'] != null) {
      speakers = <Speakers>[];
      json['speakers'].forEach((v) {
        speakers!.add(new Speakers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['topic'] = this.topic;
    data['description'] = this.description;
    data['from_time'] = this.fromTime;
    data['to_time'] = this.toTime;
    data['is_break'] = this.isBreak;
    if (this.speakers != null) {
      data['speakers'] = this.speakers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Speakers {
  String? firstName;
  String? lastName;
  String? name;
  String? jobTitle;
  String? company;
  String? headshot;

  Speakers(
      {this.firstName,
        this.lastName,
        this.name,
        this.jobTitle,
        this.company,
        this.headshot});

  Speakers.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    name = json['name'];
    jobTitle = json['job_title'];
    company = json['company'];
    headshot = json['headshot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['name'] = this.name;
    data['job_title'] = this.jobTitle;
    data['company'] = this.company;
    data['headshot'] = this.headshot;
    return data;
  }
}
