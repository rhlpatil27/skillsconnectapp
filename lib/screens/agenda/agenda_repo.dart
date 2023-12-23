
import 'dart:io';

import 'package:pce/models/agenda/agenda_response.dart';
import 'package:pce/models/agenda/filter/get_all_days.dart';
import 'package:pce/models/agenda/filter/get_all_zones.dart';
import 'package:pce/models/user_events/update_details_model.dart';

import '../../models/delegates/delegates_responce_entity.dart';
import '../../models/partners/partners_categories.dart';
import '../../models/partners/partners_model.dart';
import '../../models/speakers/speakers_model.dart';
import '../../models/user_events/countries_model.dart';
import '../../network/api_provider.dart';

class AgendaRepo {
  AgendaRepo._privateConstructor();

  static final AgendaRepo instance = AgendaRepo._privateConstructor();

  Future<AgendaResponse> getAgendaDetails(Map<String, dynamic>? body) async {
    final response =
        await ApiProvider.instance.post("get_agenda_details", body);
    return AgendaResponse.fromJson(response);
  }


  Future<DelegatesResponseEntity> getDelegatesDetails(Map<String, dynamic>? body) async {
    final response =
    await ApiProvider.instance.post("get_all_delegates", body);
    return DelegatesResponseEntity.fromJson(response);
  }

  Future<UpdateDetailsModel> updateUserDetails(Map<String, dynamic>? body) async {
    final response =
    await ApiProvider.instance.post("update_user_details", body);
    return UpdateDetailsModel.fromJson(response);
  }

  Future<SpeakersModel> getSpeakers(Map<String, dynamic>? body) async {
    final response =
    await ApiProvider.instance.post("get_all_speakers", body);
    return SpeakersModel.fromJson(response);
  }

  Future<UpdateDetailsModel> updatePhoto(File body,String userId) async {
    // Map<String, dynamic> body = {
    //   "user_id": userId, //eventId ?? '',
    //   'headshot' : body
    // };
    final response = await ApiProvider.instance.uploadImage("update_profile_photo", body,userId);
    return UpdateDetailsModel.fromJson(response);
  }

  Future<PartnersModel> getPartners(Map<String, dynamic>? body) async {
    final response =
    await ApiProvider.instance.post("get_all_partners", body);
    return PartnersModel.fromJson(response);
  }

  Future<PartnersCategoriesModel> getPartnersCategory(Map<String, dynamic>? body) async {
    final response =
    await ApiProvider.instance.post("get_all_partner_categories", body);
    return PartnersCategoriesModel.fromJson(response);
  }

  Future<CountriesModel> getCountryDetails() async {
    final response =
    await ApiProvider.instance.get("get_all_countries");
    return CountriesModel.fromJson(response);
  }

  Future<GetAllDays> getAllDays(Map<String, dynamic>? body) async {
    final response =
    await ApiProvider.instance.post("get_all_days", body);
    return GetAllDays.fromJson(response);
  }

  Future<GetAllZones> getAllZones(Map<String, dynamic>? body) async {
    final response =
    await ApiProvider.instance.post("get_all_zones", body);
    return GetAllZones.fromJson(response);
  }

}
