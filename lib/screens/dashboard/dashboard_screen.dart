import 'dart:async';

import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pce/base_widgets/app_textstyle.dart';
import 'package:pce/models/login/LoginResponse.dart';
import 'package:pce/models/screen_arguments.dart';
import 'package:pce/models/user_events/user_events.dart';
import 'package:pce/network/api_provider.dart';
import 'package:pce/screens/dashboard/dashboard_bloc.dart';
import 'package:pce/screens/notifications/notifications_screen.dart';
import 'package:pce/utils/constants.dart' as Constants;
import 'package:permission_handler/permission_handler.dart';

import '../../utils/singleton.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String? eventName;
  String? faqUrl,venueUrl,awardUrl,contactUrl,mapUrl,directionLink;
  String sponsorImgUrl= '';
  bool flag = false;
  UserEvents? userEvents;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchBadgeData();
    _getData();
    _getEventsData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardBloc, DashboardState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is DashboardNotiStatusFetched) {
          return SafeArea(
            child: WillPopScope(
              onWillPop: _onBackPressed,
              child: Scaffold(
                key: scaffoldKey,
                backgroundColor: AppSingleton.instance.getBackgroundColor(),
                appBar: buildAppBar(context, badgeFlag: state.response.response),
                body: buildSignInScreen(),

              ),
            ),
          );
        }
        return SafeArea(
          child: WillPopScope(
            onWillPop: _onBackPressed,
            child: Scaffold(
              key: scaffoldKey,
              backgroundColor: AppSingleton.instance.getBackgroundColor(),
              appBar: buildAppBar(context, badgeFlag: flag),
              body: buildSignInScreen(),
            ),
          ),
        );
      },
    );
  }

  Widget buildSignInScreen() {
    return Container(
      color: AppSingleton.instance.getBackgroundColor(),
      child: Column(
        children: [
          buildToolbar(context, eventName ?? '', null),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: GridView.count(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const ScrollPhysics(),
              crossAxisCount: 3,
              children: List<Widget>.generate(dashboardOptions.length, (index) {
                return GestureDetector(
                  onTap: () async {
                    if (index == 0) {
                      Navigator.pushNamed(context, Constants.ROUTE_AGENDA);
                    } else if (index == 1) {
                      Navigator.pushNamed(context, Constants.ROUTE_MAP,
                      arguments: ScreenArguments(mapUrl!, directionLink!));
                    } else if (index == 2) {
                      // Navigator.pushNamed(context, Constants.ROUTE_VENUE);
                      Navigator.pushNamed(context, Constants.ROUTE_WEBVIEW,
                          arguments: ScreenArguments(venueUrl!, "Venue"));
                    } else if (index == 3) {
                      Navigator.pushNamed(context, Constants.ROUTE_DELEGATES);
                    } else if (index == 4) {
                      Navigator.pushNamed(context, Constants.ROUTE_PARTNERS);
                    } else if (index == 5) {
                      Navigator.pushNamed(context, Constants.ROUTE_SPEAKERS);
                    } else if (index == 6) {

                      var status = await Permission.camera.status;
                      if (status.isGranted) {
                        Navigator.pushNamed(context, Constants.ROUTE_QR);
                      } else {
                        var status = await Permission.camera.request();
                        if (status.isGranted) {
                          Navigator.pushNamed(context, Constants.ROUTE_QR);
                        }
                      }
                    } else if(index == 7){
                      Navigator.pushNamed(context, Constants.ROUTE_CHATS);
                    }else if (index == 8) {
                      Navigator.pushNamed(context, Constants.ROUTE_WEBVIEW,
                          arguments: ScreenArguments(contactUrl!, "Contact"));
                    } else {
                      Navigator.pushNamed(context, Constants.ROUTE_WEBVIEW,
                          arguments: ScreenArguments(faqUrl!, "FAQ"));
                    }
                  },
                  child: GridTile(
                    footer: Center(child: Text(dashboardTitles[index])),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: AppSingleton.instance.getSecondaryColor(),
                              width: 1.0),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        color: Colors.white,
                        child: Center(
                          child: Image.asset(
                            dashboardOptions[index],
                            scale: 7.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          AppSingleton.instance.bottomBar(context,sponsorImgUrl)
        ],
      ),
    );
  }

  List<String> dashboardOptions = [
    "assets/images/agenda.png",
    "assets/images/map.png",
    "assets/images/venue.png",
    "assets/images/delegates.png",
    "assets/images/partners.png",
    "assets/images/speakers.png",
    "assets/images/qrscanner.png",
    "assets/images/chat.png",
    "assets/images/contactus.png",
    "assets/images/faq.png"
  ];

  List<String> dashboardTitles = [
    "Agenda",
    "Map",
    "Venue",
    "Delegates",
    "Partners",
    "Speakers",
    "QR Scanner",
    "Chats",
    "Contact Us",
    "FAQ"
  ];

  void _showError(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(AppSingleton.instance.getErrorSnackBar(message));
  }

  void _getData() async {
    String? eName = await ApiProvider.instance.getUserEventName();
    String? url = await ApiProvider.instance.getVenueLink();
    String? url1 = await ApiProvider.instance.getAwardLink();
    String? url2 = await ApiProvider.instance.getContactLink();
    String? url3 = await ApiProvider.instance.getMapLink();
    String? url4 = await ApiProvider.instance.getDirectionLink();
    String? url5 = await ApiProvider.instance.getFaqLink();
    String? url6 = await ApiProvider.instance.getSponserLink();
    bool? flagName = await ApiProvider.instance.getShowBadge();
    setState(() {
      eventName = eName;
      venueUrl = url;
      awardUrl = url1;
      contactUrl = url2;
      mapUrl = url3;
      directionLink = url4;
      faqUrl = url5;
      sponsorImgUrl = url6 ?? "https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/No_image_3x4_50_trans_borderless.svg/120px-No_image_3x4_50_trans_borderless.svg.png";
      flag = flagName ?? false;
      debugPrint('flag===>>>> $flag');
    });
  }

  void _getEventsData() async {
    UserEvents? events = await ApiProvider.instance.getEventDetails();
    setState(() {
      userEvents = events;
    });
  }

  Widget buildToolbar(
      BuildContext context, String title, Widget? trailingIcon) {
    return ListTile(
        leading: GestureDetector(
          onTap: () {
            ApiProvider.instance.setUserEventId("0");
            Navigator.pushReplacementNamed(
                context, Constants.ROUTE_SELECT_EVENT,
                arguments: userEvents?.data);
          },
          child: Icon(
            Icons.arrow_back_rounded,
            size: 33,
            color: Colors.black,
          ),
        ),
        title: Text(
          title,
          style: AppTextStyle.bold(Colors.black87, 18.0),
        ),
        trailing: trailingIcon);
  }

  Future<bool> _onBackPressed() async {
    return await AppSingleton.instance.exitAppDialog(context);
  }

  fetchBadgeData() async {
    String? eid = await ApiProvider.instance.getUserEventId();
    LoginResponse? loginResponse = await ApiProvider.instance.getUserDetails();
    Map<String, String> body = {
      Constants.PARAM_EVENT_ID: eid ?? '',
      Constants.PARAM_TO_USERID: loginResponse?.data?.userId ?? '',
    };
    BlocProvider.of<DashboardBloc>(context).add(IsNotiStatusEvent(body: body));
  }

  PreferredSizeWidget buildAppBar(BuildContext context, {bool? badgeFlag}) {
    bool ignore  = false;
    bool flagShow  = badgeFlag ?? false;
    flag = flagShow;
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 5,
        bottomOpacity: 20,
        actions: [
          GestureDetector(
            onTap: () {
              ignore = true;
              print("Constants.current_route  ${Constants.current_route }");
              if(Constants.current_route == Constants.ROUTE_NOTIFICATIONS ){
              }else{
                Navigator.pushNamed(context,Constants.ROUTE_NOTIFICATIONS ).then((value) {
                  Constants.current_route = "";
                  debugPrint('ROUTE_NOTIFICATIONS==>> ${value.toString()}');
                  flagShow = value as bool;
                  setState(() {
                    flag = flagShow;
                  });
                  fetchBadgeData();
                });
              }
            },
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: badge.Badge(
                position: const badge.BadgePosition(top: 1,end: 2),
                badgeContent: Text('',style: const TextStyle(color: Colors.red,fontSize: 14.0),),
                child: Icon(
                  Icons.notifications_none,
                  color: AppSingleton.instance.getPrimaryColor(),
                ),
                showBadge: flag,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if(Constants.current_route == Constants.ROUTE_MY_PROFILE ){
              }else{
                Navigator.pushNamed(
                    context, Constants.ROUTE_MY_PROFILE).then((value) {
                  Constants.current_route = "";
                });
              }

            },
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.supervised_user_circle_outlined,
                color: AppSingleton.instance.getPrimaryColor(),
              ),
            ),
          ),
        ],
        title: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.fill,
          // color: Colors.red,
          scale: 2.0,
        ),
      ),
    );
  }

}
