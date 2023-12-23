import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_downloader/image_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pce/Controllers/socket_controller.dart';
import 'package:pce/base_widgets/app_textstyle.dart';
import 'package:pce/models/chat/get_chat_users_response.dart';
import 'package:pce/models/chat/get_user_messages_response.dart';
import 'package:pce/models/delegates/delegates_responce_entity.dart';
import 'package:pce/models/login/LoginResponse.dart';
import 'package:pce/models/screen_arguments.dart';
import 'package:pce/network/api_provider.dart';
import 'package:pce/screens/chats/chat_bloc.dart';
import 'package:pce/screens/chats/message_bloc.dart';
import 'package:pce/screens/delegates/delegates_bloc.dart';
import 'package:pce/utils/constants.dart' as Constants;
import 'package:share_plus/share_plus.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../../utils/constants.dart';
import '../../utils/singleton.dart';

class UserChatScreen extends StatefulWidget {
  final String? name;
  final String? toUserId;
  final String? toImageUrl;
  const UserChatScreen({Key? key, required this.name,required this.toUserId,required this.toImageUrl}) : super(key: key);

  @override
  _UserChatScreenState createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String dayTitle = '';
  String filter = '';
  String filter2 = '';
  final TextEditingController name = TextEditingController();
  TextEditingController _textEditingController = TextEditingController();
  bool flag = false;
  String sponsorImgUrl= '';
  String myProfileImageUrl= '';
  String userId= '';
  GetUserMessagesResponse response =  GetUserMessagesResponse();
  // late IO.Socket socket;
  SocketController? _socketController;
  var reversedList;

  // File? _file;

  @override
  void initState() {
    super.initState();
    tzdata.initializeTimeZones();
    fetchData();
    _getNotificationData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //Initilizing and connecting to the socket
      SocketController.get(context)
        ..init()
        ..connect(
          connected: (){
            _socketController = SocketController.get(context);
            _socketController?.storeUserId(userId);
          },
          onConnectionError: (data) {
            print(data);
          },
        );
    });
    connectToServer();

  }
  void connectToServer() {
    _socketController = SocketController.get(context);
    _socketController?.socket?.on('receive_message', (data) {
      debugPrint(data.toString());
      final dataJson = json.decode(data) as Map<String, dynamic>;
      var message = GetUserMessagesResponseData.fromJson(dataJson);
      if(message.fromUserId == widget.toUserId){
        //current user screen is open then  send message to database.
        _socketController?.socket?.emit('send_message_to_database', message.toJson());
        setState(() {
          response.data?.add(message);
        });
      }else{
        //current user screen is not open then  send notification.
        _socketController?.socket?.emit('send_notification_user_is_not_chatting', message.toJson());
      }

    });
  }
  @override
  void dispose() {
    _textEditingController.dispose();
    _socketController?.socket?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop:  _onBackPressed,
        child: Scaffold(
          key: scaffoldKey,
          drawerEdgeDragWidth: 0,
          backgroundColor: AppSingleton.instance.getBackgroundColor(),
          appBar: AppSingleton.instance.buildAppBar(context, badgeFlag: flag),
          body: buildChatScreen(),
        ),
      ),
    );
  }
Widget buildChatScreen(){
    return Stack(
      children: [
        Positioned.fill(
          top: 0,
          bottom: null,
          child: Container(
            color: AppSingleton.instance.getBackgroundColor(),
            child: AppSingleton.instance.buildToolbar(
                context,
                widget.name ?? "",
                null,
                flag,
                chatFlag: true
            ),
          ),
        ),
        Positioned.fill(
          top: 50,
            bottom: 10,
            child: buildChatMsgScreen(),
        ),
        Positioned.fill(
          top: null,
          bottom: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16,vertical: 14),
            color: AppSingleton.instance.getBackgroundColor(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: 54,
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 4,),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: Color(0xFFDCC5B5), width: 1),
                        borderRadius: BorderRadius.circular(24)),
                    child: TextField(
                      cursorColor: Color(0xFF000000),
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        iconColor: Colors.black12,
                          suffixIcon: IconButton(
                            color: Color(0xFFDCC5B5).withOpacity(0.5),
                            onPressed: () async {
                              File? filepath = await getImageFromGallery();
                              debugPrint(filepath.toString());
                              if(filepath != null)
                                BlocProvider.of<MessageBloc>(context).add(UserMessageImageSendEvent(body: filepath,userId: userId,response: response));
                              },
                            icon: Icon(Icons.add_a_photo_rounded),
                          ),
                          hintText: "Type a message |",
                          hintStyle: TextStyle(
                              fontSize: 16.0
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 16.0),
                  decoration: BoxDecoration(
                      color: Color(0xFFDCC5B5),
                      border: Border.all(
                          color: Color(0xFFDCC5B5), width: 1),
                      borderRadius: BorderRadius.circular(24)),
                  child: IconButton(
                    color: Colors.white,
                    onPressed: () {
                      if(validation()){
                        _sendMessage(_textEditingController.text.toString(),null);
                      }else{
                        _showError('Please enter message!');
                      }
                      },
                    icon: Icon(Icons.send),
                  ),
                ),
              ],
            ),
          ),
        )

      ],
    );
}
  Widget chatListScreen(GetUserMessagesResponse response,int index){
     reversedList = response.data?.reversed.toList();

    bool isSelf = false;
    if(reversedList?[index]?.fromUserId == userId){
      isSelf = true;
    }else{
      isSelf = false;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 4),
      color: AppSingleton.instance.getBackgroundColor(),
      child: Row(
        mainAxisAlignment: isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isSelf ? Container() : Container(
            margin: EdgeInsets.only(right: 4,),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  // image: NetworkImage('https://pceuat.convstaging.com/${reversedList?[index]?.imageUrl ?? "assets/user_assets/custom/img/sample.jpg"}',)
                  image: NetworkImage('${reversedList?[index]?.imageUrl ?? "https://pceuat.convstaging.com/assets/user_assets/custom/img/sample.jpg"}',)
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: isSelf ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTapDown: (TapDownDetails details) {
                    bool isDelete = reversedList?[index]?.toUserId == userId ? false : true;
                  _showPopupMenu(details.globalPosition,reversedList?[index]?.message?.trim(),reversedList?[index]?.tempId,index,isDelete,reversedList?[index]?.attachment ?? '');
                  },
                  onDoubleTap: (){
                    Navigator.pushNamed(context, Constants.ROUTE_IMAGE_OPEN,
                        arguments: ScreenArguments(reversedList?[index]?.attachment!, ""));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8,),
                    decoration: BoxDecoration(
                      color: isSelf ? Color(0xFFDCC5B5) : Colors.white,
                      border: Border.all(
                          color: Color(0xFFDCC5B5), width: 1),
                      borderRadius: isSelf ? BorderRadius.only(
                          bottomRight: Radius.circular(8.0),
                          topLeft: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0)
                      ) : BorderRadius.only(
                          bottomRight: Radius.circular(8.0),
                          topRight: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0)
                      ) ,
                    ),
                    child: reversedList?[index]?.attachment == null ?
                    Text(
                      reversedList?[index]?.message ?? "",
                      style: TextStyle(
                          color: isSelf ? Colors.white : Colors.black
                      ),
                    ) : getImageView(reversedList?[index]?.attachment,isSelf),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(4),
                  child: Text(getTimeFromDateTime(reversedList?[index]?.dateTime ?? ""),
                    style: TextStyle(
                        fontSize: 6
                    ),),
                )
              ],
            ),
          ),
          isSelf ? Container(
            margin: EdgeInsets.only(left: 4),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: NetworkImage(
                    '${reversedList?[index]?.imageUrl ?? "https://pceuat.convstaging.com/assets/user_assets/custom/img/sample.jpg"}',)),
            ),
          ) : Container(),
        ],
      ),

    );
  }

  Widget buildChatMsgScreen() {
    return BlocConsumer(
      bloc: BlocProvider.of<MessageBloc>(context),
      listener: (context, state) {
        if (state is MessageStateError) {
          _showError(state.error);
        }
        if(state is UsersChatImageSendSuccess){
          var response = state.response;
          if(response.url != null){
            _sendMessage(_textEditingController.text.toString(),response.url);
          }
        }
      },
      builder: (context, state) {
        if (state is UsersChatStateLoaded) {
          response = state.response;
          return response.data!.isNotEmpty ? ListView.builder(
              shrinkWrap: true,
              reverse: true,
              padding: const EdgeInsets.only(bottom: 70.0) ,
              itemCount: response.data?.length ?? 0,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return chatListScreen(response,index);
              }) : const Center(child: Text('Start a chat'));;
        }
        if (state is UsersChatImageSendSuccess) {
         var localresponse = state.msgResponse;
          return localresponse.data!.isNotEmpty ? ListView.builder(
              shrinkWrap: true,
              reverse: true,
              padding: const EdgeInsets.only(bottom: 70.0) ,
              itemCount: response.data?.length ?? 0,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return chatListScreen(response,index);
              }) : const Center(child: Text('Start a chat'));;
        }

        if (state is UsersChatDeleted) {
         var response = state.response;
         if(response.status ?? false){
           fetchData();
         }
        }
        return AppSingleton.instance.buildCenterSizedProgressBar();
      },
    );
  }

  Widget buildSignInScreen() {
    return Container(
      color: AppSingleton.instance.getBackgroundColor(),
      child: Column(
        children: [
          AppSingleton.instance.buildToolbar(
            context,
            'Chats',
              null,
              flag
          ),
        ],
      ),
    );
  }


  bool validate() {
    if (name.text.isEmpty) {
      scaffoldKey.currentState!.closeEndDrawer();
      _showError('Please enter Name');
      return false;
    } else {
      return true;
    }
  }

  Widget titleTextFieldWidget(String? title,TextEditingController controller){
    return Container(
      margin: EdgeInsets.only(left: 0.0,right: 0.0),
      child: Column(
        children: [
          SizedBox(
            height: 10.0,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Text(
                title!,
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          TextField(
            controller: controller,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 2.0),
              ),
                 border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                hintStyle: TextStyle(color: Colors.grey[800]),
                hintText: "Type in your text",
                ),
            keyboardType: TextInputType.multiline,
            // minLines: 8,
            //Normal textInputField will be displayed
            // maxLines: 8, // when user presses enter it will adapt to it
          ),
          SizedBox(
            height: 50,
          ),      ],
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

  fetchData() async {
    LoginResponse? loginResponse = await ApiProvider.instance.getUserDetails();
    userId = loginResponse?.data?.userId ?? '';
    Map<String, String> body = {
      Constants.PARAM_TO_USERID: widget.toUserId ?? '', //loginResponse?.data?.userId ?? '',
      Constants.PARAM_FROM_USERID: userId, //loginResponse?.data?.userId ?? '',
    };
    BlocProvider.of<MessageBloc>(context).add(UserMessagesEvent(body: body));
  }
  deleteMsg(var chatId,int index) async {
    LoginResponse? loginResponse = await ApiProvider.instance.getUserDetails();
    userId = loginResponse?.data?.userId ?? '';
    Map<String, String> body = {
      Constants.PARAM_TEMP_ID: chatId ?? '',
      Constants.PARAM_FROM_USERID: userId,
    };
   BlocProvider.of<MessageBloc>(context).add(UserMessageDeleteEvent(body: body));
    // reversedList.removeAt(index);
    // setState(() {
    //   // response.data?.removeAt(index);
    // });
  }
  void _getNotificationData() async {
    String? sponsorImg = await ApiProvider.instance.getSponserLink();
    bool? flagName = await ApiProvider.instance.getShowBadge();
    String? myProfileImage = await ApiProvider.instance.getProfileUrl();
    setState(() {
      sponsorImgUrl= sponsorImg ?? "";
      myProfileImageUrl= myProfileImage ?? "";
      flag = flagName ?? false;
    });
  }
  void _sendMessage(String messageTxt, String? imageUrl) {
    var message = GetUserMessagesResponseData(fromUserId: userId,toUserId: widget.toUserId,message: messageTxt,attachment: imageUrl,dateTime:
    DateTime.now().toString(),imageUrl: myProfileImageUrl,tempId: Random.secure().nextInt(100000).toString());
    if (message!=null) {
      _socketController?.socket?.emit('send_message', message.toJson());
      _textEditingController.clear();
    }
    setState(() {
      response.data?.add(message);
    });

  }

  String getTimeFromDateTime(String datetime){
    if(datetime.isNotEmpty){
      DateTime parsedDate = DateTime.parse(datetime);
      bool isToday = getIsToday(parsedDate);
      if(isToday){
        String formattedTime = DateFormat.jm().format(parsedDate);
        return 'Today $formattedTime';
      }else{
       // convertDateTime(parsedDate);
        String formattedDateTime =  DateFormat('E,d MMM yyyy h:mm a').format(parsedDate.toLocal().toLocal());
        return formattedDateTime;
      }
    }
    return "";
   // DateFormat.yMd().add_jm().format(parsedDate)
  }

  // String convertDateTime(DateTime dateTime){
  //   // Define the timezone you want to convert to
  //   String targetTimezone = 'America/New_York'; // Replace with your desired timezone
  //
  //   // Get the time zone object for the target timezone
  //   final targetTimeZone = tz.getLocation(targetTimezone);
  //
  //   // Convert the Indian datetime to the target timezone
  //   final convertedDateTime = tz.TZDateTime.from(dateTime, targetTimeZone);
  //   String formattedDateTime =  DateFormat('E,d MMM yyyy h:mm a').format(convertedDateTime);
  //   return formattedDateTime;
  // }

  bool getIsToday(DateTime datetime){
    DateTime now = DateTime.now();
    Duration diff = now.difference(datetime);
    if(diff.inDays == 0){
      return true;
    }else{
      return false;
    }
  }

  bool validation(){
    if(_textEditingController.text.trim().isEmpty){
      return false;
    }
    return true;
  }

  Future<bool> _onBackPressed() async {
    Navigator.pop(context,true);
    return true;
  }
  //for image

  void _showPopupMenu(Offset offset,String text,var chatId,int index, bool isDeleteShow,String url) async {
    double left = offset.dx;
    double top = offset.dy;
    debugPrint(text);
    if(text != null && text.isNotEmpty){
      await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(left, top, left+1, top+1),
        items: isDeleteShow ? [
          PopupMenuItem<String>(
              onTap: () {
                copyText(text);
              },
              child: Text('Copy')),
          PopupMenuItem<String>(
              onTap: () => share(text, url),
              child: const Text('Share'), value: ''),
          PopupMenuItem<String>(
              onTap: (){
                deleteMsg(chatId,index);
              },
              child: const Text('Delete'), value: 'Lion')
        ] : [
          PopupMenuItem<String>(
              onTap: () {
                  copyText(text);
              },
              child: Text('Copy')),
          PopupMenuItem<String>(
              onTap: () => share(text, url), value: '',
              child: const Text('Share')),
        ],
        elevation: 8.0,
      );
    }else {
      await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(left, top, left + 1, top + 1),
        items: isDeleteShow ? [
          // PopupMenuItem<String>(
          //     onTap: () {
          //         copyText(text);
          //     },
          //     child: Text('Copy')),
          PopupMenuItem<String>(
              onTap: () => share(text, url),
              child: const Text('Share')),
          PopupMenuItem<String>(
              onTap: () {
                deleteMsg(chatId, index);
              },
              child: const Text('Delete'))
        ] : [
          PopupMenuItem<String>(
              onTap: () => share(text, url),
              child: const Text('Share')),
        ],
        elevation: 8.0,
      );
    }
  }

  void share(String text, String imageUrl) async{
    if(text.isNotEmpty){
      Share.share(text);
    }else{
      // final response = await Uri.parse(imageUrl);
      // final directory = await getTemporaryDirectory();
      // File file = await File('${directory.path}/Image.png')
      //     .writeAsBytes(response.);
      //
      // await Share.shareXFiles([XFile(file.path)], text: 'Share');
      Directory tempDir = await getTemporaryDirectory();
      final path = '${tempDir.path}/image.jpg';

      await Dio().download(BASE_URL+imageUrl, path);

      Share.shareXFiles([XFile(path)], text: '');
    }
  }
  void copyText(var copyText){
    Clipboard.setData(ClipboardData(text: copyText));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Copied to Clipboard")));
  }
  // void download(var url) async {
  //   try {
  //     var imageId = await ImageDownloader.downloadImage(url);
  //     if (imageId == null) {
  //       return;
  //     }
  //     var path = await ImageDownloader.findPath(imageId);
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Image downloaded.")));
  //   } on PlatformException catch (error) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Unable to download")));
  //     print(error);
  //   }
  // }

  Future<File?> getImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 80);
    File file;
     if (pickedFile != null) {
       file = File(pickedFile.path);
       return file;
     } else {
        print('No image selected.');
      }
    return null;

  }

  // Widget getImageView(var imageUrl){
  //   if(_file != null){
  //     return Image.file(_file!,fit: BoxFit.cover,);
  //   }else{
  //     return Image.network(imageUrl ?? "");
  //   }
  // }
  Widget getImageView(var imageUrl,bool isSelf){
      return Padding(
        padding: isSelf ? EdgeInsets.only(left: 8.0) :EdgeInsets.only(right: 8.0),
        // child: Image.network(BASE_URL+imageUrl,fit: BoxFit.cover,),
        child:     CachedNetworkImage(
          imageUrl: BASE_URL+imageUrl,
          progressIndicatorBuilder: (context,
              url,
              downloadProgress) =>
              CircularProgressIndicator(
                value: downloadProgress
                    .progress,
                color: Colors
                    .grey[
                100],
              ),
          errorWidget: (context,
              url,
              error) =>
              Icon(Icons
                  .rectangle_outlined),
        ),
      );
  }
}

