import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';
import 'package:pce/network/api_provider.dart';
import 'package:pce/utils/constants.dart' as Constants;
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utils/singleton.dart';

class MapScreen extends StatefulWidget {
  final String mapUrl,directionUrl;
  const MapScreen({Key? key,required this.mapUrl,required this.directionUrl}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  var loadingPercentage = 0;
  var lat = 19.080584591687582;
  var lng = 72.89829679106927;
  var initUrl;
  bool flag = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initUrl = widget.mapUrl;
    // initUrl = "https://www.google.com/maps?ll=38.87301,-77.007433&z=16&t=m&hl=en&gl=IN&mapclient=embed&cid=6988172398827564427";
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
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
          AppSingleton.instance.buildToolbar(context, 'Map', null,flag),
          Expanded(
            child: AbsorbPointer(
              child: WebView(
                gestureNavigationEnabled: false,
                zoomEnabled: false,
                initialUrl: initUrl != null ? initUrl : "https://maps.google.com/",
                // initialUrl: 'https://www.google.com/maps/search/?api=1&query=19.080804510837908%2C72.89957813396958',
                // initialUrl: 'https://www.google.com/maps/search/?api=1&query=19.080804510837908%2C72.89957813396958',
                // initialUrl: 'https://www.google.com/maps/@?api=1&map_action=map&center=19.080804510837908%2C72.89957813396958&zoom=15',
                javascriptMode: JavascriptMode.unrestricted,
                backgroundColor: const Color(0x00000000),
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
                onPageStarted: (url) {
                  setState(() {
                    loadingPercentage = 0;
                  });
                },
                onProgress: (progress) {
                  setState(() {
                    loadingPercentage = progress;
                  });
                },
                onPageFinished: (url) {
                  setState(() {
                    loadingPercentage = 100;
                  });
                },
              ),
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
                navigateTo(38.8731770566754,-77.00742227123324);
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
    // var uri = Uri.parse("http://maps.google.com/maps?q=loc:${lat},${lng}");
    var uri = Uri.parse(widget.directionUrl);
    if (!await launchUrl(uri,mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $uri';
    }
  }

  void _getNotificationData() async {
    bool? flagName = await ApiProvider.instance.getShowBadge();
    setState(() {
      flag = flagName ?? false;
    });
  }

}

