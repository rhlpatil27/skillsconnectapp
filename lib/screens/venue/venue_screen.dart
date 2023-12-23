import 'dart:async';

import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';
import 'package:pce/network/api_provider.dart';
import 'package:pce/utils/constants.dart' as Constants;

import '../../utils/singleton.dart';

class VenueScreen extends StatefulWidget {
  const VenueScreen({Key? key}) : super(key: key);

  @override
  _VenueScreenState createState() => _VenueScreenState();
}

class _VenueScreenState extends State<VenueScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final controller = MapController(
    location: const LatLng(0, 0),
    zoom: 2,
  );
  bool flag = false;
  String sponsorImgUrl= '';

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
        appBar: AppSingleton.instance.buildAppBar(context, badgeFlag: flag),
        body: buildSignInScreen(),
      ),
    );
  }

  Widget buildSignInScreen() {
    return Container(
      color: AppSingleton.instance.getBackgroundColor(),
      child: Column(
        children: [
          AppSingleton.instance.buildToolbar(context, 'Venue', null,flag),
          Expanded(
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    color: AppSingleton.instance.getCardEdgeColor(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.picture_as_pdf,
                          size: 45,
                        ),
                        title: Text(
                          'Partner Showcase',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                );
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

  void _getNotificationData() async {
    String? sponsorImg = await ApiProvider.instance.getSponserLink();
    bool? flagName = await ApiProvider.instance.getShowBadge();
    setState(() {
      sponsorImgUrl= sponsorImg ?? "";
      flag = flagName ?? false;
    });
  }
}
