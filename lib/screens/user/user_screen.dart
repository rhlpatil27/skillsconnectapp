import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pce/network/api_provider.dart';
import 'package:pce/utils/constants.dart' as Constants;

import '../../utils/singleton.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  _OtherUserScreenState createState() => _OtherUserScreenState();
}

class _OtherUserScreenState extends State<UserScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool flag = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getNotificationData();
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
    return Container(
      color: AppSingleton.instance.getBackgroundColor(),
      child: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            AppSingleton.instance.buildToolbar(
              context,
              'My Profile',
              Icon(
                Icons.filter_alt_rounded,
                size: 33,
                color: Colors.black,
              ),
                flag
            ),
            CircleAvatar(
              backgroundColor: AppSingleton.instance.getCardEdgeColor(),
              radius: 100.0,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(
                    'https://scores.iplt20.com/ipl/playerimages/215-small.png'),
                radius: 94.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Maged El Hawary',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text(
                'Senior UI/UX Designer',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
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
                Expanded(
                  child: Chip(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: AppSingleton.instance.getCardEdgeColor(),
                    padding: EdgeInsets.all(15),
                    avatar: Icon(
                      Icons.location_on,
                      color: Colors.white,
                    ),
                    label: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'United kingdom',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
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
                child: Text(
                  'Message',
                  style: TextStyle(color: Colors.black38, fontSize: 17),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "Type in your text",
                    fillColor: Colors.white70),
                keyboardType: TextInputType.multiline,
                minLines: 10, //Normal textInputField will be displayed
                maxLines: 10, // when user presses enter it will adapt to it
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
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
                    Navigator.pushNamed(context, Constants.ROUTE_SELECT_EVENT);
                  },
                  child: const Text(
                    'SEND',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
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

  void _getNotificationData() async {
    bool? flagName = await ApiProvider.instance.getShowBadge();
    setState(() {
      flag = flagName ?? false;
    });
  }
}
