import 'dart:math';
import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pce/utils/constants.dart' as Constants;

import '../base_widgets/app_textstyle.dart';
import 'hex_color.dart';

class AppSingleton {
  AppSingleton._privateConstructor();

  static final AppSingleton instance = AppSingleton._privateConstructor();


  Widget buildToolbar(BuildContext context,String title,
      Widget? trailingIcon,bool notiFlag,{bool? chatFlag}){
    return ListTile(
      leading: GestureDetector(
        onTap: (){
          // Navigator.of(context, rootNavigator: true).pop(context);
          chatFlag == true ? Navigator.pop(context,true) :  Navigator.pop(context, notiFlag);
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
      trailing: trailingIcon
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context, {bool? badgeFlag}) {
    bool ignore  = false;
    bool flag  = badgeFlag ?? false;

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
                  flag = value as bool;
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
  PreferredSizeWidget bottomBar(BuildContext context,String url) {

    return PreferredSize(
      preferredSize: const Size.fromHeight(10),
      child: Card(
        elevation: 30,
        shadowColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('App Sponsor :',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey[600]),),
              Container(
                height: MediaQuery.of(context).size.height * 0.06,width: MediaQuery.of(context).size.width/2,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                      style: BorderStyle.solid
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.network(url,), //https://www.ril.com/App_Themes/RIL/images/generic/RIL_Logo.png
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLoading() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Please wait..',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 30,
          ),
          AppSingleton.instance.buildCenterSizedProgressBar()
        ],
      ),
    );
  }

  getCardEdgeColor(){
    return HexColor('#dabdae');
  }

  getPrimaryColor() {
    return HexColor('#514e4b');
  }

  getTitleTextColor() {
    return HexColor('#2b2b2b');
  }

  getTextColor() {
    return HexColor('#545453');
  }

  getHintColor() {
    return HexColor('#bfbfbf');
  }

  getSecondaryColor() {
    return HexColor('#c9b9ab');
  }

  getButtonColor() {
    return HexColor('#2f2f2f');
  }

  getBackgroundColor(){
    return Colors.grey[100];
  }

  getDarkBlueColor() {
    return HexColor('#2E3D4D');
  }

  getCardDarkGray() {
    return HexColor('#eeecee');
  }

  getLightGrayColor() {
    return Colors.grey[200];
  }

  dynamic getHeight(double height) {
    return ScreenUtil().setHeight(height);
  }

  dynamic getWidth(double width) {
    return ScreenUtil().setWidth(width);
  }

  dynamic getSp(double size) {
    return ScreenUtil().setSp(size);
  }

  Widget getSpacer() {
    return SizedBox(
      height: getHeight(15),
    );
  }

  Widget getHorizontalSpacer() {
    return SizedBox(
      height: getWidth(10),
    );
  }

  Widget getHozSizedSpacer(double size) {
    return SizedBox(
      width: getWidth(size),
    );
  }

  Widget getSizedSpacer(double size) {
    return SizedBox(
      height: getHeight(size),
    );
  }

  SnackBar getErrorSnackBar(String message) {
    return SnackBar(
      duration: const Duration(seconds: 5),
      content: Center(
        heightFactor: 1.0,
        child: Text(
          message,
          style: AppTextStyle.regular(Colors.white, 15.0),
        ),
      ),
      backgroundColor: Colors.red,
    );
  }

  SnackBar getSuccessSnackBar(String message) {
    return SnackBar(
      duration: const Duration(seconds: 5),
      content: Center(
        heightFactor: 1.0,
        child: Text(
          '$message',
          style: AppTextStyle.regular(Colors.white, 15.0),
        ),
      ),
      backgroundColor: Colors.green,
    );
  }

  Future<bool> exitAppDialog(BuildContext context) async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure'),
            content: Text('Do you want to exit an App?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  Future<bool> goBack(BuildContext context) async {
    Navigator.of(context).pop(true);
    return false;
  }

  dynamic generateRandomColor() {
    return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }

  Widget getBlankContainer() {
    return Container(
      height: 0,
      width: 0,
    );
  }

  OutlineInputBorder getLightGrayOutLineBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(
        color: getLightGrayColor(),
      ),
    );
  }

  Widget buildCenterSizedProgressBar() {
    return Center(
      child: SizedBox(
        height: getHeight(30),
        width: getWidth(30),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            getPrimaryColor(),
          ),
        ),
      ),
    );
  }

  Widget buildCenterSizedColorProgressBar(Color color) {
    return Center(
      child: SizedBox(
        height: getHeight(30),
        width: getWidth(30),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            color,
          ),
        ),
      ),
    );
  }

  void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}');
    pattern.allMatches(text).forEach((match) => debugPrint(match.group(0)));
  }

  String? getHHMMAMPM(String? dateTimeString) {
    if (dateTimeString == null) {
      return '--:--';
    }
    final dateTime = DateTime.parse(dateTimeString);
    final format = DateFormat('HH:mm a');
    return format.format(dateTime);
  }

}
