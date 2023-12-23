import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pce/network/api_provider.dart';
import 'package:pce/screens/notifications/notifications_screen.dart';
import 'package:pce/screens/splash/splash_bloc.dart';
import 'package:pce/utils/constants.dart' as Constants;
import 'package:pce/utils/constants.dart';

import '../../base_widgets/app_textstyle.dart';
import '../../utils/singleton.dart';

class ImageOpen extends StatefulWidget {
  String imageUrl;
  ImageOpen({Key? key,required this.imageUrl}) : super(key: key);

  @override
  _ImageOpenState createState() => _ImageOpenState();
}

class _ImageOpenState extends State<ImageOpen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final navKey = new GlobalKey<NavigatorState>();
  @override
  void initState() {
    super.initState();
    // BlocProvider.of<SplashBloc>(context).add(SplashEvent(fcmId: ''));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        body: buildUI(),
      ),
    );
  }

  Widget buildUI() {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white30,
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Stack(
              children: [
                Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(Icons.close),
                          color: Colors.black,
                          onPressed: () => Navigator.of(context).pop(),
                        )
                    ),
                    Center(
                      child:  CachedNetworkImage(
                        imageUrl: BASE_URL+widget.imageUrl ?? "",
                        progressIndicatorBuilder: (context,
                            url,
                            downloadProgress) =>
                            CircularProgressIndicator(
                              value: downloadProgress
                                  .progress,
                              color: Colors
                                  .grey[
                              500],
                            ),
                        errorWidget: (context,
                            url,
                            error) =>
                            Icon(Icons
                                .cancel_outlined),
                      ),
                    ),

                  ],
                ),
              )
              ],
            ),
          ),
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
