import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pce/models/QrCode/QrCodeDetails.dart';
import 'package:pce/models/login/LoginResponse.dart';
import 'package:pce/network/api_provider.dart';
import 'package:pce/screens/user/other_user/send_msg_bloc.dart';
import 'package:pce/utils/constants.dart' as Constants;
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/singleton.dart';

class OtherUserScreen extends StatefulWidget {
  final dynamic? response;
  final int flag;
  const OtherUserScreen({Key? key, this.response, required this.flag}) : super(key: key);

  @override
  _OtherUserScreenState createState() => _OtherUserScreenState();
}

class _OtherUserScreenState extends State<OtherUserScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _message = TextEditingController();
  String? userId;
  String? eventId = "";
  bool flagBool = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getNotificationData();
    getEventId();
    _getData();
  }
  @override
  Widget build(BuildContext context) {
    debugPrint('QrCodeDetails${widget.response.toString()}');
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: AppSingleton.instance.getBackgroundColor(),
        appBar: AppSingleton.instance.buildAppBar(context, badgeFlag: flagBool),
        body: buildOtherUserScreen(),
      ),
    );
  }

  Widget buildOtherUserScreen() {
    return Container(
      color: AppSingleton.instance.getBackgroundColor(),
      child: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            AppSingleton.instance.buildToolbar(
              context,
              widget.flag == 2 ? 'Speakers':'Delegates',
              Visibility(
                visible: false,
                child: Icon(
                  Icons.filter_alt_rounded,
                  size: 33,
                  color: Colors.black,
                ),
              ),
              flagBool
            ),
            SizedBox(
              height: ScreenUtil().screenHeight * 0.18,
              child: CircleAvatar(
                backgroundColor: AppSingleton.instance.getCardEdgeColor(),
                radius: 100.0,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(widget.response.headshot ?? 'https://pceuat.convstaging.com/assets/user_assets/custom/img/sample.jpg'),
                  radius: 65.0,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                getNameString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2),
              child: Text(
                widget.response?.jobTitle ?? "",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2),
              child: Text(
                widget.response.company ?? "",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: (){
                      if(widget.response.linkedinLink  != null || widget.response.linkedinLink != ""){
                        _launchURLBrowser(widget.response.linkedinLink ?? '');
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
                  flex: 1,
                  child: GestureDetector(
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
                          widget.response?.country != null ? widget.response.country :  '',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Divider(
                thickness: 2,
              ),
            ),
            Visibility(
              visible: widget.flag == 0 ? true : false,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        widget.flag == 0 ? 'Note':'Message',
                        style: TextStyle(color: Colors.black87, fontSize: 17),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: _message,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          hintText: "Type in your text",
                          fillColor: Colors.white70),
                      keyboardType: TextInputType.multiline,
                      minLines: 8,
                      //Normal textInputField will be displayed
                      maxLines: 8, // when user presses enter it will adapt to it
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
                      child: BlocConsumer<SendMsgBloc, SendMsgState>(
                        listener: (context, state) {
                          if(state is SendMsgFailed){
                            _showError(state.error);
                          }
                          if(state is SendMsgLoaded){
                            _showSuccessMessage(state.response.msg ?? "Success");
                            Navigator.popAndPushNamed(context, Constants.ROUTE_DASHBOARD);
                          }
                        },
                        builder: (context, state) {
                          if(state is SendMsgLoading){
                            return AppSingleton.instance
                                .buildCenterSizedProgressBar();
                          }
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: AppSingleton.instance.getButtonColor(),
                              elevation: 4,
                              shadowColor: AppSingleton.instance.getButtonColor(),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onPressed: () async {
                              addNotification();
                            },
                            child: Text(
                              widget.flag == 0 ? 'SAVE':'SEND',
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            widget.response?.id == userId ? Container() :
            Visibility(
                visible: widget.flag == 0 ? false :true,
                child: SizedBox(
                  width: ScreenUtil().screenWidth - 16,
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
                      Navigator.pushNamed(context, Constants.ROUTE_USER_CHAT,arguments: widget.response);
                    },
                    child: Text(
                      'START A CHAT',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                )),
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
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(AppSingleton.instance.getErrorSnackBar(message));
  }

  String getNameString() {

    if(widget.response?.title == "" || widget.response?.title == null){
      return '${widget.response?.firstName} '
          '${widget.response?.lastName} ';
    }else {
      return '${widget.response?.title}'
          '.'
          ' ${widget.response?.firstName} '
          '${widget.response?.lastName} ';
    }

  }

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }


  getEventId() async{
    String? eid = await ApiProvider.instance.getUserEventId();
    eventId = eid;
  }

  void addNotification() {
    if (validate()) {
      if(widget.flag == 0){
        Map<String, String> body = {
          Constants.PARAM_EVENT_ID: eventId ?? "0",
          Constants.PARAM_FROM_USERID: userId ?? '',
          Constants.PARAM_TO_USERID: widget.response?.id ?? "",
          Constants.PARAM_NOTE: _message.text,
        };
        BlocProvider.of<SendMsgBloc>(context).add(SendMsgButtonEvent(body: body, flag: widget.flag));

      }else{
        Map<String, String> body = {
          Constants.PARAM_EVENT_ID: eventId ?? "0",
          Constants.PARAM_FROM_USERID: userId ?? '',
          Constants.PARAM_TO_USERID: widget.response?.fromUserId ?? "",
          Constants.PARAM_MESSAGE: _message.text,
        };
        BlocProvider.of<SendMsgBloc>(context).add(SendMsgButtonEvent(body: body, flag: widget.flag));
      }
    }
  }

  bool validate() {
    if (_message.text.isEmpty) {
      _showError('Please enter data');
      return false;
    } else {
      return true;
    }
  }

  void _getData() async{
    LoginResponse? response = await ApiProvider.instance.getUserDetails();
    userId =  response?.data?.userId;
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
      flagBool = flagName ?? false;
    });
  }

}
