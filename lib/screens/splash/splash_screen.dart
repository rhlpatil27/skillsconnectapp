import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pce/network/api_provider.dart';
import 'package:pce/screens/notifications/notifications_screen.dart';
import 'package:pce/screens/splash/splash_bloc.dart';
import 'package:pce/utils/constants.dart' as Constants;

import '../../base_widgets/app_textstyle.dart';
import '../../utils/singleton.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final navKey = new GlobalKey<NavigatorState>();
  bool isNotificationCame = false;
  // It is assumed that all messages contain a data field with the key 'type'
  Future<bool> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    bool flag = false;
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      print('before _handleBgMessage was clicked splash ${initialMessage.data}');
      flag = true;
      _handleBgMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBgMessage);

    return flag;
  }
  void _handleBgMessage(RemoteMessage payload) {
    isNotificationCame = true;
    print('_handleBgMessage splash was clicked splash ${payload.data}');
    // if (payload.data['type'] == 'noti') {
      print('local notification was clicked splash ${payload.data}');
      // Navigator.pushNamed(scaffoldKey.currentContext!, Constants.ROUTE_NOTIFICATIONS);
      // Navigator.pushNamed(context, Constants.ROUTE_NOTIFICATIONS);
      // navKey.currentState!.push(MaterialPageRoute(builder: (context) => NotificationsScreen()));
    // }
  }
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SplashBloc>(context).add(SplashEvent(fcmId: ''));

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        body: BlocConsumer(
          bloc: BlocProvider.of<SplashBloc>(context),
          listener: (context, state) {
            if (state is SplashLoaded) {
              _navigate(validateData(),isNotificationCame, null);
            }
            if (state is SplashError) {
              _navigate(false,isNotificationCame, state.msg);
            }
          },
          builder: (context, state) {
            if (state is SplashError) {
              if (state.msg == 'No Internet connection') {
                return buildUI(true);
              } else {
                return buildUI(false);
              }
            }
            return buildUI(false);
          },
        ),
      ),
    );
  }

  Widget buildUI(bool showNoInternet) {
    return Container(
      color: AppSingleton.instance.getPrimaryColor(),
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.all(50.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Image.asset(
                'assets/images/logo_old.png',
                fit: BoxFit.fill,
                scale: 2.0,
              ),
            ),
            showNoInternet
                ? Center(
                    child: Text(
                      'No active internet connection!',
                      style: AppTextStyle.bold(
                        AppSingleton.instance.getPrimaryColor(),
                        AppSingleton.instance.getSp(16.0),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  bool validateData() {
    return true;
  }

  void _navigate(bool isLoggedIn,bool isNotificationGet, String? msg) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    Timer(const Duration(seconds: 1), () {
      if (isLoggedIn) {
        if(isNotificationGet){
          Navigator.pushNamed(context, Constants.ROUTE_NOTIFICATIONS);
        }else{
          Navigator.pushNamed(context, Constants.ROUTE_DASHBOARD);
        }
      } else {
        if (msg == null) {
          Navigator.pushNamedAndRemoveUntil(
              context, Constants.ROUTE_LOGIN, (Route<dynamic> route) => false);
        } else {
          if (msg == 'No Internet connection') {
          } else {
            Navigator.pushNamedAndRemoveUntil(context, Constants.ROUTE_LOGIN,
                (Route<dynamic> route) => false);
          }
        }
      }
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(AppSingleton.instance.getErrorSnackBar(message));
  }
}
