class UserEvents {
  bool? status;
  List<Data>? data;

  UserEvents({this.status, this.data});

  UserEvents.fromJson(Map<String, dynamic> json) {
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
    return 'UserEvents{status: $status, data: $data}';
  }
}

class Data {
  String? id;
  String? siteId;
  String? sliderId;
  String? title;
  String? slug;
  String? shortDescription;
  String? description;
  String? eventDate;
  String? eventEndDate;
  String? locationId;
  String? hideDefaultTabs;
  String? displayInMobileApp;
  String? createdBy;
  String? createdOn;
  String? modifiedBy;
  String? modifiedOn;
  String? venueAppLink;
  String? appLocation;
  String? directionsLink;
  String? awardsLink;
  String? contactLink;
  String? mapLink;
  String? faqLink;
  String? appSponsor;

  Data(
      {this.id,
        this.siteId,
        this.sliderId,
        this.title,
        this.slug,
        this.shortDescription,
        this.description,
        this.eventDate,
        this.eventEndDate,
        this.locationId,
        this.hideDefaultTabs,
        this.displayInMobileApp,
        this.createdBy,
        this.createdOn,
        this.modifiedBy,
        this.modifiedOn,
        this.venueAppLink,
        this.appLocation,
        this.directionsLink,
        this.awardsLink,
        this.contactLink,
        this.mapLink,
        this.faqLink,
        this.appSponsor,
      });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    siteId = json['site_id'];
    sliderId = json['slider_id'];
    title = json['title'];
    slug = json['slug'];
    shortDescription = json['short_description'];
    description = json['description'];
    eventDate = json['event_date'];
    eventEndDate = json['event_end_date'];
    locationId = json['location_id'];
    hideDefaultTabs = json['hide_default_tabs'];
    displayInMobileApp = json['display_in_mobile_app'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    modifiedBy = json['modified_by'];
    modifiedOn = json['modified_on'];
    venueAppLink = json['venue_app_link'];
    appLocation = json['app_location'];
    directionsLink = json['directions_link'];
    awardsLink = json['award_link'];
    contactLink = json['contact_link'];
    mapLink = json['map_link'];
    faqLink = json['faq_link'];
    appSponsor = json['app_sponsor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['site_id'] = this.siteId;
    data['slider_id'] = this.sliderId;
    data['title'] = this.title;
    data['slug'] = this.slug;
    data['short_description'] = this.shortDescription;
    data['description'] = this.description;
    data['event_date'] = this.eventDate;
    data['event_end_date'] = this.eventEndDate;
    data['location_id'] = this.locationId;
    data['hide_default_tabs'] = this.hideDefaultTabs;
    data['display_in_mobile_app'] = this.displayInMobileApp;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['modified_by'] = this.modifiedBy;
    data['modified_on'] = this.modifiedOn;
    data['venue_app_link'] = this.venueAppLink;
    data['app_location'] = this.appLocation;
    data['directions_link'] = this.directionsLink;
    data['award_link'] = this.awardsLink;
    data['contact_link'] = this.contactLink;
    data['map_link'] = this.mapLink;
    data['faq_link'] = this.faqLink;
    data['app_sponsor'] = this.appSponsor;
    return data;
  }

  @override
  String toString() {
    return 'Data{id: $id, siteId: $siteId, sliderId: $sliderId, title: $title, slug: $slug, shortDescription: $shortDescription, description: $description, eventDate: $eventDate, eventEndDate: $eventEndDate, locationId: $locationId, hideDefaultTabs: $hideDefaultTabs, displayInMobileApp: $displayInMobileApp, createdBy: $createdBy, createdOn: $createdOn, modifiedBy: $modifiedBy, modifiedOn: $modifiedOn, venueAppLink: $venueAppLink, appLocation: $appLocation, directionsLink: $directionsLink, awardsLink: $awardsLink, contactLink: $contactLink, mapLink: $mapLink, faqLink: $faqLink, appSponser:$appSponsor}';
  }
}
