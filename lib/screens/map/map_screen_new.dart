import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/singleton.dart';

class MapScreenNew extends StatefulWidget {
  const MapScreenNew({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreenNew> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(45.521563, -122.677433);
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  var lat = 19.080584591687582;
  var lng = 72.89829679106927;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppSingleton.instance.buildAppBar(context),
        body: buildMapScreen(),
      ),
    );
  }

  Widget buildMapScreen() {
    return Container(
      color: AppSingleton.instance.getBackgroundColor(),
      child: Column(
        children: [
          AppSingleton.instance.buildToolbar(context, 'Map', null,false),
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            color: AppSingleton.instance.getButtonColor(),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: AppSingleton.instance.getButtonColor(),
                elevation: 4,
                shadowColor: AppSingleton.instance.getButtonColor(),
              ),
              onPressed: () async {
                navigateTo(19.080584591687582,72.89829679106927);
              },
              child: const Text(
                'GET DIRECTION',
                style: TextStyle(
                    color: Colors.white, fontSize: 18),
              ),
            ),
          )
        ],
      ),
    );
  }

  // navigateTo(19.080584591687582,72.89829679106927);
  void navigateTo(double lat, double lng) async {
    var uri = Uri.parse("http://maps.google.com/maps?q=loc:${lat},${lng}");
    if (!await launchUrl(uri,mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $uri';
    }
  }

}

