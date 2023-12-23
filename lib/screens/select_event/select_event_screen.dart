import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pce/models/login/LoginResponse.dart';
import 'package:pce/models/user_events/user_events.dart' as UserEvents;

// import 'package:pce/models/login/LoginResponse.dart';
import 'package:pce/network/api_provider.dart';
import 'package:pce/screens/login/login_bloc.dart';
import 'package:pce/screens/select_event/fcm_update_bloc.dart';
import 'package:pce/utils/constants.dart' as Constants;

import '../../base_widgets/app_textstyle.dart';
import '../../models/user_events/user_events.dart' as user_events;
import '../../utils/singleton.dart';

class SelectEventScreen extends StatefulWidget {
  List<UserEvents.Data> data;

  SelectEventScreen({Key? key, required this.data}) : super(key: key);

  @override
  _SelectEventScreenState createState() => _SelectEventScreenState();
}

class _SelectEventScreenState extends State<SelectEventScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String firstName = '';
  String? userId = '';
  String? fcmToken = '';
  String? selectedData = 'Select Event';
  String? selectedDataId = '0';
  String? venueLink = '';
  String? awardLink = '';
  String? contactLink = '';
  String? mapLink = '';
  String? directionLink = '';
  String? faqLink = '';
  String? appSponsor = '';
  UserEvents.Data selectedDataListItem = UserEvents.Data();
  List<String> dataForEvents = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsername();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: AppSingleton.instance.getPrimaryColor(),
          body: buildScreen(),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    return await AppSingleton.instance.exitAppDialog(context);
  }

  Widget buildScreen() {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      fit: StackFit.loose,
      children: <Widget>[
        Positioned.fill(
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: double.infinity,
              height: AppSingleton.instance.getWidth(200),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppSingleton.instance.getSecondaryColor(),
                  AppSingleton.instance.getPrimaryColor()
                ],
              )),
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/logo_old.png",
                  width: AppSingleton.instance.getWidth(250),
                  height: AppSingleton.instance.getWidth(200),
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: ScreenUtil().screenHeight * 0.7,
              child: Card(
                margin: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                )),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: Text(
                          'Welcome ${firstName}',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 22),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 30, bottom: 10, right: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Please select the event',
                                style: AppTextStyle.bold(Colors.black87, 24.0),
                              ),
                              Icon(
                                Icons.supervised_user_circle_outlined,
                                color: Colors.grey,
                                size: AppSingleton.instance.getWidth(50),
                              )
                            ],
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: DropdownSearch<dynamic>(
                        popupProps: PopupProps.menu(
                          fit: FlexFit.loose,
                          showSelectedItems: false,
                        ),
                        items: widget.data.map((e) => e.title).toList(),
                        //['Project Controls Expo 2022','Project Controls Expo 2022'],
                        // items: dataForEvents, //['Project Controls Expo 2022','Project Controls Expo 2022'],
                        onChanged: (dynamic? item) {
                          selectedData = item;
                            widget.data.map((item) {
                              if(selectedData == item.title){
                                selectedDataId = item.id;
                                venueLink = item.venueAppLink;
                                awardLink = item.awardsLink;
                                contactLink = item.contactLink;
                                mapLink = item.mapLink;
                                directionLink = item.directionsLink;
                                faqLink = item.faqLink;
                                appSponsor = item.appSponsor;
                              }
                          }).toList();
                          debugPrint('selectedDataId::: $selectedDataId');
                          ApiProvider.instance.setUserEventId(selectedDataId);
                          ApiProvider.instance.setUserEventName(selectedData);
                          ApiProvider.instance.setVenueLink(venueLink);
                          ApiProvider.instance.setAwardLink(awardLink);
                          ApiProvider.instance.setContactLink(contactLink);
                          ApiProvider.instance.setMapLink(mapLink);
                          ApiProvider.instance.setDirectionLink(directionLink);
                          ApiProvider.instance.setFaqLink(faqLink);
                          ApiProvider.instance.setSponserLink(appSponsor);
                          debugPrint('venueLink::: $venueLink');
                          debugPrint('awardLink::: $awardLink');
                          debugPrint('contactLink::: $contactLink');
                          debugPrint('mapLink::: $mapLink');
                          debugPrint('faqLink::: $faqLink');
                          debugPrint('appSponsor::: $appSponsor');
                        },
                        selectedItem: selectedData,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: SizedBox(
                width: double.infinity,
                height: AppSingleton.instance.getHeight(60),
                child: BlocConsumer<FcmUpdateBloc, FcmUpdateState>(
                  listener: (context, state) {
                    // TODO: implement listener
                    if(state is FcmKeyUpdateFailed){
                      _showError(state.error);
                    }
                    if(state is FcmKeyUpdateDone){
                      Navigator.pushNamed(context, Constants.ROUTE_DASHBOARD);
                    }
                  },
                  builder: (context, state) {

                    if(state is FcmKeyUpdateLoading){
                      return AppSingleton.instance
                          .buildCenterSizedProgressBar();
                    }
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppSingleton.instance.getButtonColor(),
                        elevation: 4,
                        shadowColor: AppSingleton.instance.getButtonColor(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {
                        gotoDashboard();
                      },
                      child: const Text(
                        'PROCEED',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  void gotoDashboard() {
    if (selectedDataId == "0") {
     _showError('Please select event');
    } else {
      addClickEvent();
      selectedDataId = "0";
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(AppSingleton.instance.getErrorSnackBar(message));
  }

  List<String> createEventList(List<UserEvents.Data> list) {
    List<String> listOfEvents = [];
    list.forEach((element) {
      listOfEvents.add(element.title!);
    });
    return listOfEvents;
  }

  void getUsername() async {
    LoginResponse? response = await ApiProvider.instance.getUserDetails();
    // String? fcm = await ApiProvider.instance.getFcmToken() ;
    setState(() {
      firstName = response?.data?.firstName ?? '';
      userId = response?.data?.userId ?? '';
      // fcmToken = fcm ?? '';
    });
  }

  addClickEvent() async {
    try {
      String? fcmDeviceToken = await FirebaseMessaging.instance.getToken();
      if(fcmDeviceToken != null){
        print('fcmDeviceToken - $fcmDeviceToken');
        await ApiProvider.instance.setFcmToken(fcmDeviceToken);
      }else{
        print('fcmDeviceToken else- $fcmDeviceToken');
      }
    }catch (error){
      print('fcmDeviceToken error - $error');
    }
    fcmToken = await ApiProvider.instance.getFcmToken();
    print("FCM TOKEN $fcmToken");
     Map<String, String> body = {
      Constants.PARAM_USER_ID: userId ?? '',
      Constants.PARAM_FCM_TOKEN: await ApiProvider.instance.getFcmToken() ?? 'sffas',
    };
    BlocProvider.of<FcmUpdateBloc>(context).add(FcmKeyUpdateEvent(body: body));
  }
}
