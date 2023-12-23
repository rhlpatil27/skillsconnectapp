import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pce/models/user_events/my_profile.dart';
import 'package:pce/models/user_events/user_events.dart';
import 'package:pce/network/api_provider.dart';
import 'package:pce/screens/user/my_profile_bloc.dart';
import 'package:pce/utils/constants.dart' as Constants;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/singleton.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  MyProfileModel responce = MyProfileModel();
  String? userId="";
  String? eventId="";
  bool flag = false;

  @override
  void initState() {
    super.initState();
    _getNotificationData();
    getUserId();
    fetchData();
  }

  fetchData(){
    Map<String, String> body = {
      Constants.PARAM_USER_ID: userId!, //getUserId() ?? '',
    };
    BlocProvider.of<MyProfileBloc>(context).add(MyProfileEvent(body: body));
  }

  getUserId() async{
    userId =  await ApiProvider.instance.getUserId();
    eventId =  await ApiProvider.instance.getUserEventId();
   }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: AppSingleton.instance.getBackgroundColor(),
        appBar: AppSingleton.instance.buildAppBar(context, badgeFlag: flag),
        body: buildSignInScreen(),
      ),
    );
  }


  Widget buildSignInScreen() {
    return BlocConsumer(
      bloc: BlocProvider.of<MyProfileBloc>(context),
      listener: (context, state) {
        if (state is MyProfileError) {
          _showError(state.error);
        }if (state is MyProfileLoaded) {
          responce = state.response;
        }
        if (state is ExportLeadsError) {
          _showError(state.error);
        } if (state is ExportLeadsLoaded) {
          _showSuccessMessage(state.response.msg!);
        }
      },
      builder: (context, state) {
        if (responce.data != null) {
          ApiProvider.instance.setProfileUrl(responce.data?.headshot ?? "");
          // var responce = state.response.data;
          return buildSignInScreen1();
        }
        return AppSingleton.instance.buildCenterSizedProgressBar();
      },
    );
  }


  Widget buildSignInScreen1() {
    return Container(
      color: AppSingleton.instance.getBackgroundColor(),
      child: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              children: [
                AppSingleton.instance.buildToolbar(
                  context,
                  'My Profile',
                 Container(
                   width: 0.0,
                   height: 0.0,
                 ),
                    flag
                ),
                CircleAvatar(
                  backgroundColor: AppSingleton.instance.getCardEdgeColor(),
                  radius: 100.0,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(
                        responce.data!.headshot ?? "https://scores.iplt20.com/ipl/playerimages/215-small.png"),
                    radius: 94.0,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "${responce.data!.firstName} ${responce.data!.lastName!}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    '${responce.data!.jobTitle!}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,color: Colors.black38),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    '${responce.data!.company!}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,color: Colors.black38),
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          // Navigator.pushNamed(context, Constants.ROUTE_WEBVIEW, arguments: responce.data!.linkedinLink ?? "");
                          if(responce.data!.linkedinLink != null || responce.data!.linkedinLink  != ""){
                            _launchURLBrowser(responce.data!.linkedinLink ?? "");
                          }else {
                            _showError("Can't load url");
                          }
                        },
                        child: Chip(
                          backgroundColor: Colors.black,
                          padding: EdgeInsets.all(15),
                          avatar: Icon(
                            Icons.link,
                            color: Colors.white,
                          ),
                          label: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'Linkedin',
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          Constants.responce = responce;
                          Navigator.pushNamed(context, Constants.ROUTE_EDIT_PROFILE).then((value) {
                            if(value == true){
                              getUserId();
                              Map<String, String> body = {
                                Constants.PARAM_USER_ID: userId!, //getUserId() ?? '',
                              };
                              BlocProvider.of<MyProfileBloc>(context).add(MyProfileEvent(body: body));
                            };

                          });

                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 15.0),
                          child: Chip(
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            backgroundColor: AppSingleton.instance.getCardEdgeColor(),
                            padding: EdgeInsets.all(15),
                            avatar: Icon(
                              Icons.edit,
                              color: Colors.black,
                            ),
                            label: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'Edit Profile',
                                style: TextStyle(
                                    color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Divider(
                    thickness: 2,
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        Icon(Icons.call,color: Colors.black38,size: 18.0,),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          'Phone - ',
                          style: TextStyle(color: Colors.black38, fontSize: 17),
                        ),
                        Text(
                          '${responce.data!.phone!}',
                          style: TextStyle(color: Colors.black, fontSize: 17,fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        Icon(Icons.email,color: Colors.black38,size: 18.0,),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          'Email - ',
                          style: TextStyle(color: Colors.black38, fontSize: 17),
                        ),
                        Expanded(
                          child: Text(
                            '${responce.data!.email}',
                            style: TextStyle(color: Colors.black, fontSize: 17,fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        Icon(Icons.flag,color: Colors.black38,size: 18.0,),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          'Country - ',
                          style: TextStyle(color: Colors.black38, fontSize: 17),
                        ),
                        Text(
                          '${responce.data!.country}',
                          style: TextStyle(color: Colors.black, fontSize: 17,fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  // SizedBox(
                  //   width: ScreenUtil().screenWidth,
                  //   height: ScreenUtil().screenHeight * 0.08,
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //       primary: AppSingleton.instance.getCardEdgeColor(),
                  //       elevation: 4,
                  //       shadowColor: AppSingleton.instance.getButtonColor(),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(10.0),
                  //       ),
                  //     ),
                  //     onPressed: () async {
                  //       Map<String, String> body = {
                  //         Constants.PARAM_EVENT_ID: eventId!,
                  //         Constants.PARAM_SACNNED_USERID: userId!,
                  //       };
                  //       BlocProvider.of<MyProfileBloc>(context).add(ExportLeadsEvent(body: body));
                  //       },
                  //     child: const Text(
                  //       'Export Leads',
                  //       style: TextStyle(color: Colors.black, fontSize: 18),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 10.0,
                  // ),
                  SizedBox(
                    width: ScreenUtil().screenWidth,
                    height: ScreenUtil().screenHeight * 0.08,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppSingleton.instance.getButtonColor(),
                        elevation: 4,
                        shadowColor: AppSingleton.instance.getButtonColor(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.clear();
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil(Constants.ROUTE_LOGIN, (Route<dynamic> route) => false);
                      },
                      child: const Text(
                        'LOG OUT',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(AppSingleton.instance.getSuccessSnackBar(message));
 /*   Timer(const Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, Constants.ROUTE_DASHBOARD);
    });*/
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(AppSingleton.instance.getErrorSnackBar(message));
  }

  _launchURLBrowser(String gotoUrl) async {
    var url = Uri.parse(gotoUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url,mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _getNotificationData() async {
    bool? flagName = await ApiProvider.instance.getShowBadge();
    setState(() {
      flag = flagName ?? false;
    });
  }
}
