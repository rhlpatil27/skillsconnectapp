import 'package:pce/generated/json/base/json_convert_content.dart';
import 'package:pce/models/agenda/agenda_response.dart';
import 'package:pce/models/agenda/agenda_response_entity.dart';

AgendaResponseEntity $AgendaResponseEntityFromJson(Map<String, dynamic> json) {
	final AgendaResponseEntity agendaResponseEntity = AgendaResponseEntity();
	final bool? status = jsonConvert.convert<bool>(json['status']);
	if (status != null) {
		agendaResponseEntity.status = status;
	}
	final List<AgendaResponseData>? data = jsonConvert.convertListNotNull<AgendaResponseData>(json['data']);
	if (data != null) {
		agendaResponseEntity.data = data;
	}
	return agendaResponseEntity;
}

Map<String, dynamic> $AgendaResponseEntityToJson(AgendaResponseEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['status'] = entity.status;
	data['data'] =  entity.data?.map((v) => v.toJson()).toList();
	return data;
}

AgendaResponseData $AgendaResponseDataFromJson(Map<String, dynamic> json) {
	final AgendaResponseData agendaResponseData = AgendaResponseData();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		agendaResponseData.id = id;
	}
	final String? eventId = jsonConvert.convert<String>(json['event_id']);
	if (eventId != null) {
		agendaResponseData.eventId = eventId;
	}
	final String? dayName = jsonConvert.convert<String>(json['day_name']);
	if (dayName != null) {
		agendaResponseData.dayName = dayName;
	}
	final String? abbreviation = jsonConvert.convert<String>(json['abbreviation']);
	if (abbreviation != null) {
		agendaResponseData.abbreviation = abbreviation;
	}
	final String? date = jsonConvert.convert<String>(json['date']);
	if (date != null) {
		agendaResponseData.date = date;
	}
	final String? location = jsonConvert.convert<String>(json['location']);
	if (location != null) {
		agendaResponseData.location = location;
	}
	final String? status = jsonConvert.convert<String>(json['status']);
	if (status != null) {
		agendaResponseData.status = status;
	}
	final String? createdBy = jsonConvert.convert<String>(json['created_by']);
	if (createdBy != null) {
		agendaResponseData.createdBy = createdBy;
	}
	final String? createdOn = jsonConvert.convert<String>(json['created_on']);
	if (createdOn != null) {
		agendaResponseData.createdOn = createdOn;
	}
	final dynamic? modifiedBy = jsonConvert.convert<dynamic>(json['modified_by']);
	if (modifiedBy != null) {
		agendaResponseData.modifiedBy = modifiedBy;
	}
	final dynamic? modifiedOn = jsonConvert.convert<dynamic>(json['modified_on']);
	if (modifiedOn != null) {
		agendaResponseData.modifiedOn = modifiedOn;
	}
	final List<AgendaResponseDataZones>? zones = jsonConvert.convertListNotNull<AgendaResponseDataZones>(json['zones']);
	if (zones != null) {
		agendaResponseData.zones = zones;
	}
	return agendaResponseData;
}

Map<String, dynamic> $AgendaResponseDataToJson(AgendaResponseData entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['event_id'] = entity.eventId;
	data['day_name'] = entity.dayName;
	data['abbreviation'] = entity.abbreviation;
	data['date'] = entity.date;
	data['location'] = entity.location;
	data['status'] = entity.status;
	data['created_by'] = entity.createdBy;
	data['created_on'] = entity.createdOn;
	data['modified_by'] = entity.modifiedBy;
	data['modified_on'] = entity.modifiedOn;
	data['zones'] =  entity.zones?.map((v) => v.toJson()).toList();
	return data;
}

AgendaResponseDataZones $AgendaResponseDataZonesFromJson(Map<String, dynamic> json) {
	final AgendaResponseDataZones agendaResponseDataZones = AgendaResponseDataZones();
	final String? zoneId = jsonConvert.convert<String>(json['zone_id']);
	if (zoneId != null) {
		agendaResponseDataZones.zoneId = zoneId;
	}
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		agendaResponseDataZones.id = id;
	}
	final String? zoneName = jsonConvert.convert<String>(json['zone_name']);
	if (zoneName != null) {
		agendaResponseDataZones.zoneName = zoneName;
	}
	final String? abbreviation = jsonConvert.convert<String>(json['abbreviation']);
	if (abbreviation != null) {
		agendaResponseDataZones.abbreviation = abbreviation;
	}
	final List<AgendaResponseDataZonesDayAndZoneSessions>? dayAndZoneSessions = jsonConvert.convertListNotNull<AgendaResponseDataZonesDayAndZoneSessions>(json['day_and_zone_sessions']);
	if (dayAndZoneSessions != null) {
		agendaResponseDataZones.dayAndZoneSessions = dayAndZoneSessions;
	}
	return agendaResponseDataZones;
}

Map<String, dynamic> $AgendaResponseDataZonesToJson(AgendaResponseDataZones entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['zone_id'] = entity.zoneId;
	data['id'] = entity.id;
	data['zone_name'] = entity.zoneName;
	data['abbreviation'] = entity.abbreviation;
	data['day_and_zone_sessions'] =  entity.dayAndZoneSessions?.map((v) => v.toJson()).toList();
	return data;
}

AgendaResponseDataZonesDayAndZoneSessions $AgendaResponseDataZonesDayAndZoneSessionsFromJson(Map<String, dynamic> json) {
	final AgendaResponseDataZonesDayAndZoneSessions agendaResponseDataZonesDayAndZoneSessions = AgendaResponseDataZonesDayAndZoneSessions();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		agendaResponseDataZonesDayAndZoneSessions.id = id;
	}
	final String? siteId = jsonConvert.convert<String>(json['site_id']);
	if (siteId != null) {
		agendaResponseDataZonesDayAndZoneSessions.siteId = siteId;
	}
	final String? eventId = jsonConvert.convert<String>(json['event_id']);
	if (eventId != null) {
		agendaResponseDataZonesDayAndZoneSessions.eventId = eventId;
	}
	final String? topic = jsonConvert.convert<String>(json['topic']);
	if (topic != null) {
		agendaResponseDataZonesDayAndZoneSessions.topic = topic;
	}
	final String? description = jsonConvert.convert<String>(json['description']);
	if (description != null) {
		agendaResponseDataZonesDayAndZoneSessions.description = description;
	}
	final String? dayId = jsonConvert.convert<String>(json['day_id']);
	if (dayId != null) {
		agendaResponseDataZonesDayAndZoneSessions.dayId = dayId;
	}
	final String? zoneId = jsonConvert.convert<String>(json['zone_id']);
	if (zoneId != null) {
		agendaResponseDataZonesDayAndZoneSessions.zoneId = zoneId;
	}
	final String? timeSlotId = jsonConvert.convert<String>(json['time_slot_id']);
	if (timeSlotId != null) {
		agendaResponseDataZonesDayAndZoneSessions.timeSlotId = timeSlotId;
	}
	final String? primarySpeakerId = jsonConvert.convert<String>(json['primary_speaker_id']);
	if (primarySpeakerId != null) {
		agendaResponseDataZonesDayAndZoneSessions.primarySpeakerId = primarySpeakerId;
	}
	final String? primarySpeakerPresenterLink = jsonConvert.convert<String>(json['primary_speaker_presenter_link']);
	if (primarySpeakerPresenterLink != null) {
		agendaResponseDataZonesDayAndZoneSessions.primarySpeakerPresenterLink = primarySpeakerPresenterLink;
	}
	final String? isBreak = jsonConvert.convert<String>(json['is_break']);
	if (isBreak != null) {
		agendaResponseDataZonesDayAndZoneSessions.isBreak = isBreak;
	}
	final dynamic? sessionPresentation = jsonConvert.convert<dynamic>(json['session_presentation']);
	if (sessionPresentation != null) {
		agendaResponseDataZonesDayAndZoneSessions.sessionPresentation = sessionPresentation;
	}
	final dynamic? sessionPresentationFileName = jsonConvert.convert<dynamic>(json['session_presentation_file_name']);
	if (sessionPresentationFileName != null) {
		agendaResponseDataZonesDayAndZoneSessions.sessionPresentationFileName = sessionPresentationFileName;
	}
	final dynamic? polls = jsonConvert.convert<dynamic>(json['polls']);
	if (polls != null) {
		agendaResponseDataZonesDayAndZoneSessions.polls = polls;
	}
	final dynamic? pollsFileName = jsonConvert.convert<dynamic>(json['polls_file_name']);
	if (pollsFileName != null) {
		agendaResponseDataZonesDayAndZoneSessions.pollsFileName = pollsFileName;
	}
	final dynamic? handouts = jsonConvert.convert<dynamic>(json['handouts']);
	if (handouts != null) {
		agendaResponseDataZonesDayAndZoneSessions.handouts = handouts;
	}
	final dynamic? handoutsFileName = jsonConvert.convert<dynamic>(json['handouts_file_name']);
	if (handoutsFileName != null) {
		agendaResponseDataZonesDayAndZoneSessions.handoutsFileName = handoutsFileName;
	}
	final dynamic? pastEventDocument = jsonConvert.convert<dynamic>(json['past_event_document']);
	if (pastEventDocument != null) {
		agendaResponseDataZonesDayAndZoneSessions.pastEventDocument = pastEventDocument;
	}
	final String? videoLink = jsonConvert.convert<String>(json['video_link']);
	if (videoLink != null) {
		agendaResponseDataZonesDayAndZoneSessions.videoLink = videoLink;
	}
	final String? status = jsonConvert.convert<String>(json['status']);
	if (status != null) {
		agendaResponseDataZonesDayAndZoneSessions.status = status;
	}
	final dynamic? createdBy = jsonConvert.convert<dynamic>(json['created_by']);
	if (createdBy != null) {
		agendaResponseDataZonesDayAndZoneSessions.createdBy = createdBy;
	}
	final String? createdOn = jsonConvert.convert<String>(json['created_on']);
	if (createdOn != null) {
		agendaResponseDataZonesDayAndZoneSessions.createdOn = createdOn;
	}
	final String? modifiedBy = jsonConvert.convert<String>(json['modified_by']);
	if (modifiedBy != null) {
		agendaResponseDataZonesDayAndZoneSessions.modifiedBy = modifiedBy;
	}
	final String? modifiedOn = jsonConvert.convert<String>(json['modified_on']);
	if (modifiedOn != null) {
		agendaResponseDataZonesDayAndZoneSessions.modifiedOn = modifiedOn;
	}
	final String? title = jsonConvert.convert<String>(json['title']);
	if (title != null) {
		agendaResponseDataZonesDayAndZoneSessions.title = title;
	}
	final String? sessionNo = jsonConvert.convert<String>(json['session_no']);
	if (sessionNo != null) {
		agendaResponseDataZonesDayAndZoneSessions.sessionNo = sessionNo;
	}
	final String? fromTimeStamp = jsonConvert.convert<String>(json['from_time_stamp']);
	if (fromTimeStamp != null) {
		agendaResponseDataZonesDayAndZoneSessions.fromTimeStamp = fromTimeStamp;
	}
	final String? toTimeStamp = jsonConvert.convert<String>(json['to_time_stamp']);
	if (toTimeStamp != null) {
		agendaResponseDataZonesDayAndZoneSessions.toTimeStamp = toTimeStamp;
	}
	final String? timeZone = jsonConvert.convert<String>(json['time_zone']);
	if (timeZone != null) {
		agendaResponseDataZonesDayAndZoneSessions.timeZone = timeZone;
	}
	final String? firstName = jsonConvert.convert<String>(json['first_name']);
	if (firstName != null) {
		agendaResponseDataZonesDayAndZoneSessions.firstName = firstName;
	}
	final String? lastName = jsonConvert.convert<String>(json['last_name']);
	if (lastName != null) {
		agendaResponseDataZonesDayAndZoneSessions.lastName = lastName;
	}
	final String? jobTitle = jsonConvert.convert<String>(json['job_title']);
	if (jobTitle != null) {
		agendaResponseDataZonesDayAndZoneSessions.jobTitle = jobTitle;
	}
	final String? company = jsonConvert.convert<String>(json['company']);
	if (company != null) {
		agendaResponseDataZonesDayAndZoneSessions.company = company;
	}
	final String? headshot = jsonConvert.convert<String>(json['headshot']);
	if (headshot != null) {
		agendaResponseDataZonesDayAndZoneSessions.headshot = headshot;
	}
	final String? bio = jsonConvert.convert<String>(json['bio']);
	if (bio != null) {
		agendaResponseDataZonesDayAndZoneSessions.bio = bio;
	}
	final List<AgendaResponseDataZonesDayAndZoneSessionsSpeakerDetails>? speakerDetails = jsonConvert.convertListNotNull<AgendaResponseDataZonesDayAndZoneSessionsSpeakerDetails>(json['speaker_details']);
	if (speakerDetails != null) {
		agendaResponseDataZonesDayAndZoneSessions.speakerDetails = speakerDetails;
	}
	return agendaResponseDataZonesDayAndZoneSessions;
}

Map<String, dynamic> $AgendaResponseDataZonesDayAndZoneSessionsToJson(AgendaResponseDataZonesDayAndZoneSessions entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['site_id'] = entity.siteId;
	data['event_id'] = entity.eventId;
	data['topic'] = entity.topic;
	data['description'] = entity.description;
	data['day_id'] = entity.dayId;
	data['zone_id'] = entity.zoneId;
	data['time_slot_id'] = entity.timeSlotId;
	data['primary_speaker_id'] = entity.primarySpeakerId;
	data['primary_speaker_presenter_link'] = entity.primarySpeakerPresenterLink;
	data['is_break'] = entity.isBreak;
	data['session_presentation'] = entity.sessionPresentation;
	data['session_presentation_file_name'] = entity.sessionPresentationFileName;
	data['polls'] = entity.polls;
	data['polls_file_name'] = entity.pollsFileName;
	data['handouts'] = entity.handouts;
	data['handouts_file_name'] = entity.handoutsFileName;
	data['past_event_document'] = entity.pastEventDocument;
	data['video_link'] = entity.videoLink;
	data['status'] = entity.status;
	data['created_by'] = entity.createdBy;
	data['created_on'] = entity.createdOn;
	data['modified_by'] = entity.modifiedBy;
	data['modified_on'] = entity.modifiedOn;
	data['title'] = entity.title;
	data['session_no'] = entity.sessionNo;
	data['from_time_stamp'] = entity.fromTimeStamp;
	data['to_time_stamp'] = entity.toTimeStamp;
	data['time_zone'] = entity.timeZone;
	data['first_name'] = entity.firstName;
	data['last_name'] = entity.lastName;
	data['job_title'] = entity.jobTitle;
	data['company'] = entity.company;
	data['headshot'] = entity.headshot;
	data['bio'] = entity.bio;
	data['speaker_details'] =  entity.speakerDetails?.map((v) => v.toJson()).toList();
	return data;
}

AgendaResponseDataZonesDayAndZoneSessionsSpeakerDetails $AgendaResponseDataZonesDayAndZoneSessionsSpeakerDetailsFromJson(Map<String, dynamic> json) {
	final AgendaResponseDataZonesDayAndZoneSessionsSpeakerDetails agendaResponseDataZonesDayAndZoneSessionsSpeakerDetails = AgendaResponseDataZonesDayAndZoneSessionsSpeakerDetails();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		agendaResponseDataZonesDayAndZoneSessionsSpeakerDetails.id = id;
	}
	final String? eventSessionId = jsonConvert.convert<String>(json['event_session_id']);
	if (eventSessionId != null) {
		agendaResponseDataZonesDayAndZoneSessionsSpeakerDetails.eventSessionId = eventSessionId;
	}
	final String? speakerId = jsonConvert.convert<String>(json['speaker_id']);
	if (speakerId != null) {
		agendaResponseDataZonesDayAndZoneSessionsSpeakerDetails.speakerId = speakerId;
	}
	final String? presenterLink = jsonConvert.convert<String>(json['presenter_link']);
	if (presenterLink != null) {
		agendaResponseDataZonesDayAndZoneSessionsSpeakerDetails.presenterLink = presenterLink;
	}
	final String? createdBy = jsonConvert.convert<String>(json['created_by']);
	if (createdBy != null) {
		agendaResponseDataZonesDayAndZoneSessionsSpeakerDetails.createdBy = createdBy;
	}
	final String? createdOn = jsonConvert.convert<String>(json['created_on']);
	if (createdOn != null) {
		agendaResponseDataZonesDayAndZoneSessionsSpeakerDetails.createdOn = createdOn;
	}
	final String? modifiedBy = jsonConvert.convert<String>(json['modified_by']);
	if (modifiedBy != null) {
		agendaResponseDataZonesDayAndZoneSessionsSpeakerDetails.modifiedBy = modifiedBy;
	}
	final String? modifiedOn = jsonConvert.convert<String>(json['modified_on']);
	if (modifiedOn != null) {
		agendaResponseDataZonesDayAndZoneSessionsSpeakerDetails.modifiedOn = modifiedOn;
	}
	final String? firstName = jsonConvert.convert<String>(json['first_name']);
	if (firstName != null) {
		agendaResponseDataZonesDayAndZoneSessionsSpeakerDetails.firstName = firstName;
	}
	final String? lastName = jsonConvert.convert<String>(json['last_name']);
	if (lastName != null) {
		agendaResponseDataZonesDayAndZoneSessionsSpeakerDetails.lastName = lastName;
	}
	final String? jobTitle = jsonConvert.convert<String>(json['job_title']);
	if (jobTitle != null) {
		agendaResponseDataZonesDayAndZoneSessionsSpeakerDetails.jobTitle = jobTitle;
	}
	final String? company = jsonConvert.convert<String>(json['company']);
	if (company != null) {
		agendaResponseDataZonesDayAndZoneSessionsSpeakerDetails.company = company;
	}
	final String? headshot = jsonConvert.convert<String>(json['headshot']);
	if (headshot != null) {
		agendaResponseDataZonesDayAndZoneSessionsSpeakerDetails.headshot = headshot;
	}
	final String? bio = jsonConvert.convert<String>(json['bio']);
	if (bio != null) {
		agendaResponseDataZonesDayAndZoneSessionsSpeakerDetails.bio = bio;
	}
	return agendaResponseDataZonesDayAndZoneSessionsSpeakerDetails;
}

Map<String, dynamic> $AgendaResponseDataZonesDayAndZoneSessionsSpeakerDetailsToJson(AgendaResponseDataZonesDayAndZoneSessionsSpeakerDetails entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['event_session_id'] = entity.eventSessionId;
	data['speaker_id'] = entity.speakerId;
	data['presenter_link'] = entity.presenterLink;
	data['created_by'] = entity.createdBy;
	data['created_on'] = entity.createdOn;
	data['modified_by'] = entity.modifiedBy;
	data['modified_on'] = entity.modifiedOn;
	data['first_name'] = entity.firstName;
	data['last_name'] = entity.lastName;
	data['job_title'] = entity.jobTitle;
	data['company'] = entity.company;
	data['headshot'] = entity.headshot;
	data['bio'] = entity.bio;
	return data;
}