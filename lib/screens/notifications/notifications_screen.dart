import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pce/models/login/LoginResponse.dart';
import 'package:pce/network/api_provider.dart';
import 'package:pce/screens/notifications/notification_bloc.dart';
import 'package:pce/utils/constants.dart' as Constants;

import '../../utils/singleton.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool flag = false;
  String sponsorImgUrl= '';

  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    fetchNotificationData();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: AppSingleton.instance.getBackgroundColor(),
        appBar: AppSingleton.instance.buildAppBar(context, badgeFlag: flag),
        body: buildNotificationScreen(),
      ),
    );
  }

  Widget buildNotificationScreen() {
    return Container(
      color: AppSingleton.instance.getBackgroundColor(),
      child: Column(
        children: [
          AppSingleton.instance.buildToolbar(
            context,
            'Notifications',
            Visibility(
              visible: false,
              child: Icon(
                Icons.filter_alt_rounded,
                size: 33,
                color: Colors.black,
              ),
            ),
              flag,
            chatFlag: true
          ),
          Expanded(
            child: BlocConsumer<AllNotificationBloc, AllNotificationState>(
              listener: (context, state) {
                // TODO: implement listener
                if(state is AllNotificationError){
                  _showError(state.error);
                }
              },
              builder: (context, state) {
                if(state is AllNotificationLoaded){
                  var data = state.response.data;
                  return state.response.data != null ? ListView.builder(
                      itemCount: data?.length ?? 0,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          child: InkWell(
                            onTap: () {

                              Navigator.pushNamed(context, Constants.ROUTE_USER_CHAT,arguments: state.response.data![index]);
                              // Navigator.popAndPushNamed(context, Constants.ROUTE_OTHER_USER, arguments: state.response.data![index]);
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color:
                                    AppSingleton.instance.getSecondaryColor(),
                                    width: 2.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: Text(
                                    data?[index].message ?? "",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle:
                                  Text(data?[index].dateTime ?? ''),
                                  isThreeLine: true,
                                  dense: true,
                                  trailing:Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.reply),
                                      Text('Reply',style: TextStyle(fontSize: 12.0),)
                                    ],
                                  ) ,
                                  leading: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.brown,
                                        border: Border.all(
                                            color: Colors.white54, width: 0.1),
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                    child: Image.network(
                                      data?[index].headshot ?? "https://pceuat.convstaging.com/assets/user_assets/custom/img/sample.jpg",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }) : const Center(child: Text('No Data Found'));
                }
                if(state is AllNotificationError){
                 return const Center(child: Text('No Data Found'));
                }
                return AppSingleton.instance.buildCenterSizedProgressBar();
              },
            ),
          ),
          AppSingleton.instance.bottomBar(context,sponsorImgUrl)

        ],
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(AppSingleton.instance.getSuccessSnackBar(message));
    Timer(const Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, Constants.ROUTE_DASHBOARD);
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(AppSingleton.instance.getErrorSnackBar(message));
  }

  Map<String, dynamic> getRequestBody(String userId){
    Map<String, String> body = {
      Constants.PARAM_USER_ID: userId,
    };

    return body;
  }

  fetchNotificationData() async{
    String? sponsorImg = await ApiProvider.instance.getSponserLink();
    ApiProvider.instance.setShowBadge(false);
    bool? flagName = await ApiProvider.instance.getShowBadge();
    setState(() {
      sponsorImgUrl = sponsorImg ?? "";
      flag = flagName ?? false;
    });
    String? eid =  await ApiProvider.instance.getUserEventId();
    LoginResponse? loginResponse = await ApiProvider.instance.getUserDetails();
    Map<String, String> body = {
      Constants.PARAM_EVENT_ID: eid ?? '',
      Constants.PARAM_TO_USERID: loginResponse?.data?.userId ?? '',
    };
    BlocProvider.of<AllNotificationBloc>(context).add(FetchNotificationEvent(body: body));
  }
}
