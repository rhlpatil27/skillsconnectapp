import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pce/network/api_provider.dart';
import 'package:pce/utils/constants.dart' as Constants;
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utils/singleton.dart';

class WebviewScreen extends StatefulWidget {
  final String webviewUrl;
  final String? title;
  WebviewScreen({Key? key,required this.webviewUrl, required this.title}) : super(key: key);

  @override
  _WebviewScreenState createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  var loadingPercentage = 0;
  bool flag = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: AppSingleton.instance.getBackgroundColor(),
        appBar: AppSingleton.instance.buildAppBar(context, badgeFlag: flag),
        body: buildScreen(),
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    _getNotificationData();
  }
  Widget buildScreen() {
    print('webviewUrl ${widget.webviewUrl}');
    return Container(
      color: AppSingleton.instance.getBackgroundColor(),
      child: Column(
        children: [
          AppSingleton.instance.buildToolbar(context, widget.title ?? '', null,flag),
          loderLoading(),
          Expanded(
            child: WebView(
              initialUrl: widget.webviewUrl,
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
              navigationDelegate: (NavigationRequest request) {
                if (request.url.contains("mailto:")) {
                  launch(request.url);
                  return NavigationDecision.prevent;
                } else if (request.url.contains("tel:")) {
                  launch(request.url);
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget loderLoading(){
    if (loadingPercentage < 100) {
    return LinearProgressIndicator(
      value: loadingPercentage / 100.0,
    );
  }
    return Container();
  }

  String getTitleForWebview(){
    if(widget.webviewUrl.contains('contact')){
      return 'Contact us';
    }
    if(widget.webviewUrl.contains('venue')){
      return 'Venue';
    }
    if(widget.webviewUrl.contains('award')){
      return 'Awards';
    }
    return '';
  }

  void _getNotificationData() async {
    bool? flagName = await ApiProvider.instance.getShowBadge();
    setState(() {
      flag = flagName ?? false;
    });
  }
}

