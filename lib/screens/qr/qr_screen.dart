import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pce/models/login/LoginResponse.dart';
import 'package:pce/screens/qr/qr_bloc.dart';
import 'package:pce/utils/singleton.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:pce/utils/constants.dart' as Constants;

import '../../network/api_provider.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({Key? key}) : super(key: key);

  @override
  _QrScreenState createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  String? eventId;
  String? userId;
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEventId();
  }
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR SCANNER',style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        leading:  GestureDetector(
          onTap: (){
            Navigator.of(context, rootNavigator: true).pop(context);
          },
          child: Icon(
            Icons.arrow_back_rounded,
            size: 33,
            color: Colors.black,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Map<String, String> body = {
                Constants.PARAM_EVENT_ID: eventId!,
                Constants.PARAM_SACNNED_USERID: userId!,
              };
              BlocProvider.of<QrBloc>(context).add(ExportLeadsEvent(body: body));
            },
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Icon(
                    Icons.download_for_offline_outlined,
                    color: AppSingleton.instance.getPrimaryColor(),
                  ),
                  Text('My Leads',style: TextStyle(color: AppSingleton.instance.getPrimaryColor(),fontSize: 10.0),)
                ],
              ),
            ),
          ),
        ],
      ),

      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: BlocConsumer<QrBloc, QrState>(
                listener: (context, state) {
                  if(state is QrFailed){
                    _showError(state.error);
                    Navigator.pop(context);
                  }
                  if(state is QrLoaded){
                    Navigator.popAndPushNamed(context, Constants.ROUTE_OTHER_USER, arguments: state.response.data);
                  }
                  if (state is ExportLeadsError) {
                    _showError(state.error);
                  }
                  if (state is ExportLeadsLoaded) {
                    _showSuccessMessage(state.response.msg!);
                  }

                },
                builder: (context, state) {
                  if(state is QrLoading){
                    return Column(
                      children: [
                        Text('Scan a code'),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: AppSingleton.instance
                              .buildCenterSizedProgressBar(),
                        )
                      ],
                    );
                  }
                  if(state is QrLoaded){
                    return Column(
                      children: [
                        // Text('Scan a code'),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: AppSingleton.instance
                              .buildCenterSizedProgressBar(),
                        )
                      ],
                    );
                  }
                  if(state is ExportLeadsLoading){
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Text('Exporting Leads....'),
                              SizedBox(
                                height: 8.0,
                              ),
                              AppSingleton.instance
                                  .buildCenterSizedProgressBar(),
                            ],
                          ),
                        )
                      ],
                    );
                  }
                  return Column(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('Scan a code'),
                      ),
                    ],
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.resumeCamera();
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        BlocProvider.of<QrBloc>(context).add(QrEvent(body: getRequestBody()));
      });
      controller.dispose();
    });
  }


  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(AppSingleton.instance.getErrorSnackBar(message));
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(AppSingleton.instance.getSuccessSnackBar(message));
    /*   Timer(const Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, Constants.ROUTE_DASHBOARD);
    });*/
  }
  void getEventId() async{
    eventId =  await ApiProvider.instance.getUserEventId();
    LoginResponse? response = await ApiProvider.instance.getUserDetails();
    userId =  response?.data?.userId;
  }

    Map<String, dynamic> getRequestBody() {

    Map<String, String> body = {
      Constants.PARAM_EVENT_ID: eventId ?? "",
      Constants.PARAM_REG_CODE: result?.code ?? "",
      Constants.PARAM_SACNNED_USERID: userId ?? "",
    };

    return body;
  }
}
