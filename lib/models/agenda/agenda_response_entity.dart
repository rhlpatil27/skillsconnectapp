import 'package:pce/generated/json/base/json_field.dart';
import 'package:pce/generated/json/agenda_response_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class AgendaResponseEntity {

	bool? status;
	List<AgendaResponseData>? data;
  
  AgendaResponseEntity();

  factory AgendaResponseEntity.fromJson(Map<String, dynamic> json) => $AgendaResponseEntityFromJson(json);

  Map<String, dynamic> toJson() => $AgendaResponseEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AgendaResponseData {

	String? id;
	@JSONField(name: "event_id")
	String? eventId;
	@JSONField(name: "day_name")
	String? dayName;
	String? abbreviation;
	String? date;
	String? location;
	String? status;
	@JSONField(name: "created_by")
	String? createdBy;
	@JSONField(name: "created_on")
	String? createdOn;
	@JSONField(name: "modified_by")
	dynamic modifiedBy;
	@JSONField(name: "modified_on")
	dynamic modifiedOn;
	List<AgendaResponseDataZones>? zones;
  
  AgendaResponseData();

  factory AgendaResponseData.fromJson(Map<String, dynamic> json) => $AgendaResponseDataFromJson(json);

  Map<String, dynamic> toJson() => $AgendaResponseDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AgendaResponseDataZones {

	@JSONField(name: "zone_id")
	String? zoneId;
	String? id;
	@JSONField(name: "zone_name")
	String? zoneName;
	String? abbreviation;
	@JSONField(name: "day_and_zone_sessions")
	List<AgendaResponseDataZonesDayAndZoneSessions>? dayAndZoneSessions;
  
  AgendaResponseDataZones();

  factory AgendaResponseDataZones.fromJson(Map<String, dynamic> json) => $AgendaResponseDataZonesFromJson(json);

  Map<String, dynamic> toJson() => $AgendaResponseDataZonesToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AgendaResponseDataZonesDayAndZoneSessions {

	String? id;
	@JSONField(name: "site_id")
	String? siteId;
	@JSONField(name: "event_id")
	String? eventId;
	String? topic;
	String? description;
	@JSONField(name: "day_id")
	String? dayId;
	@JSONField(name: "zone_id")
	String? zoneId;
	@JSONField(name: "time_slot_id")
	String? timeSlotId;
	@JSONField(name: "primary_speaker_id")
	String? primarySpeakerId;
	@JSONField(name: "primary_speaker_presenter_link")
	String? primarySpeakerPresenterLink;
	@JSONField(name: "is_break")
	String? isBreak;
	@JSONField(name: "session_presentation")
	dynamic sessionPresentation;
	@JSONField(name: "session_presentation_file_name")
	dynamic sessionPresentationFileName;
	dynamic polls;
	@JSONField(name: "polls_file_name")
	dynamic pollsFileName;
	dynamic handouts;
	@JSONField(name: "handouts_file_name")
	dynamic handoutsFileName;
	@JSONField(name: "past_event_document")
	dynamic pastEventDocument;
	@JSONField(name: "video_link")
	String? videoLink;
	String? status;
	@JSONField(name: "created_by")
	dynamic createdBy;
	@JSONField(name: "created_on")
	String? createdOn;
	@JSONField(name: "modified_by")
	String? modifiedBy;
	@JSONField(name: "modified_on")
	String? modifiedOn;
	String? title;
	@JSONField(name: "session_no")
	String? sessionNo;
	@JSONField(name: "from_time_stamp")
	String? fromTimeStamp;
	@JSONField(name: "to_time_stamp")
	String? toTimeStamp;
	@JSONField(name: "time_zone")
	String? timeZone;
	@JSONField(name: "first_name")
	String? firstName;
	@JSONField(name: "last_name")
	String? lastName;
	@JSONField(name: "job_title")
	String? jobTitle;
	String? company;
	String? headshot;
	String? bio;
	@JSONField(name: "speaker_details")
	List<AgendaResponseDataZonesDayAndZoneSessionsSpeakerDetails>? speakerDetails;
  
  AgendaResponseDataZonesDayAndZoneSessions();

  factory AgendaResponseDataZonesDayAndZoneSessions.fromJson(Map<String, dynamic> json) => $AgendaResponseDataZonesDayAndZoneSessionsFromJson(json);

  Map<String, dynamic> toJson() => $AgendaResponseDataZonesDayAndZoneSessionsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AgendaResponseDataZonesDayAndZoneSessionsSpeakerDetails {

	String? id;
	@JSONField(name: "event_session_id")
	String? eventSessionId;
	@JSONField(name: "speaker_id")
	String? speakerId;
	@JSONField(name: "presenter_link")
	String? presenterLink;
	@JSONField(name: "created_by")
	String? createdBy;
	@JSONField(name: "created_on")
	String? createdOn;
	@JSONField(name: "modified_by")
	String? modifiedBy;
	@JSONField(name: "modified_on")
	String? modifiedOn;
	@JSONField(name: "first_name")
	String? firstName;
	@JSONField(name: "last_name")
	String? lastName;
	@JSONField(name: "job_title")
	String? jobTitle;
	String? company;
	String? headshot;
	String? bio;
  
  AgendaResponseDataZonesDayAndZoneSessionsSpeakerDetails();

  factory AgendaResponseDataZonesDayAndZoneSessionsSpeakerDetails.fromJson(Map<String, dynamic> json) => $AgendaResponseDataZonesDayAndZoneSessionsSpeakerDetailsFromJson(json);

  Map<String, dynamic> toJson() => $AgendaResponseDataZonesDayAndZoneSessionsSpeakerDetailsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}