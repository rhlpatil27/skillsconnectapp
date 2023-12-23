import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pce/Controllers/socket_controller.dart';
import 'package:pce/base_widgets/app_textstyle.dart';
import 'package:pce/models/chat/get_chat_users_response.dart';
import 'package:pce/models/delegates/delegates_responce_entity.dart';
import 'package:pce/models/login/LoginResponse.dart';
import 'package:pce/models/subscription_models.dart';
import 'package:pce/network/api_provider.dart';
import 'package:pce/screens/chats/chat_bloc.dart';
import 'package:pce/screens/delegates/delegates_bloc.dart';
import 'package:pce/utils/constants.dart' as Constants;
import 'package:pce/models/chat/get_chat_users_response.dart' as ChatUsers;

import '../../utils/singleton.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String dayTitle = '';
  String filter = '';
  String filter2 = '';
  final TextEditingController name = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  bool flag = false;
  String sponsorImgUrl= '';
  String userId= '';
  late GetChatUsersResponse getChatUsersResponse;
  // List<ChatUsers.Data> chatUserData = [];
  List<ChatUsers.Data> searchChatUserData = [];
  bool _isTextFieldHasContentYet = false;


  @override
  void initState() {
    super.initState();
    fetchData();
    _getNotificationData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //Start listening to the text editing controller
      _searchController.addListener(() {
        final _text = _searchController.text.trim();
        if (_text.isEmpty) {
          _isTextFieldHasContentYet = false;
         // _showError("Please enter data");
        } else {
          if(_text.length > 2){
            _isTextFieldHasContentYet = true;
            BlocProvider.of<ChatUsersBloc>(context).add(SearchChatUser(_searchController.text.trim(),response: getChatUsersResponse));
          }else{
            if(_isTextFieldHasContentYet && _text.length == 1){
              fetchData();
              _isTextFieldHasContentYet = false;
            }
           //BlocProvider.of<ChatUsersBloc>(context).add(SearchChatUser("NA",response: getChatUsersResponse));
          }
        }
        setState(() {});
      });
    });
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
          body: buildSignInScreen(),
        ),
      ),
    );
  }

  Widget buildSignInScreenUserList() {
    return Expanded(
      child: BlocConsumer(
        bloc: BlocProvider.of<ChatUsersBloc>(context),
        listener: (context, state) {
          if (state is ChatUsersStateError) {
            _showError(state.error);
          }
        },
        builder: (context, state) {
          if (state is ChatUsersStateLoaded) {
              getChatUsersResponse = state.response;
            // Timer(Duration(seconds: 10), () {
            //   print("Yeah, this line is printed after 10 seconds");
            //   BlocProvider.of<ChatUsersBloc>(context).add(UpdateUnReadCount(getChatUsersResponse.data[0].id,"3",response: state.response));
            // });
           return listViewWidget(getChatUsersResponse.data);
          }
          if (state is SearchUsersStateLoaded) {
            searchChatUserData = state.response.data;
            return  listViewWidget(searchChatUserData);
          }
          return AppSingleton.instance.buildCenterSizedProgressBar();
        },
      ),
    );
  }

  Widget listViewWidget(List<ChatUsers.Data> userChatList){
    return userChatList.isNotEmpty ?
    ListView.builder(
        itemCount: userChatList.length ?? 0,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding:
            EdgeInsets.only(left: 8, right:8,bottom: 8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context,Constants.ROUTE_USER_CHAT,arguments: userChatList[index]).then((value) {
                  userChatList[index].unreadCount =  "0";
                  debugPrint('ROUTE_USER_CHAT==>> ${value.toString()}');
                  if(value != null && value == true){
                    fetchData();
                    _searchController.clear();
                  }
                });
                // Navigator.pushNamed(context, Constants.ROUTE_USER_CHAT,arguments: chatUserData[index]);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.5, color: Color(0xFFDCC5B5)),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      userChatList[index].name,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    trailing: Visibility(
                      visible: userChatList[index].unreadCount == "0" ? false : true,
                      child: Container(
                          width: 20,
                          height: 20,
                          child:  Center(child: Text(userChatList[index].unreadCount ?? "0")),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppSingleton.instance.getSecondaryColor())
                      ),
                    ) ,
                    leading: Container(
                      width: 60,
                      height: 60,
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(
                                    userChatList[index].imageUrl
                                ),
                                fit: BoxFit.cover)
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }) : const Center(child: Text('No User Found'));
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
          searchWidget(),
          buildSignInScreenUserList(),
          AppSingleton.instance.bottomBar(context,sponsorImgUrl)
        ],
      ),
    );
  }

  Widget searchWidget(){
    return Padding(
      padding: const EdgeInsets.only(left: 16,right: 16,bottom: 14),
      child: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
            color: Color(0xFFe9eaec),
            border: Border.all(
                color: Color(0xFFDCC5B5), width: 1),
            borderRadius: BorderRadius.circular(15)),
        child: TextField(
          cursorColor: Color(0xFF000000),
          controller: _searchController,
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: Color(0xFFDCC5B5).withOpacity(0.5),
              ),
              suffixIcon:
                  Visibility(
                    visible: _isTextFieldHasContentYet,
                    child: IconButton(
                        onPressed: onPressed,
                        icon:  Icon(
                          Icons.close,
                          color: Color(0xFFDCC5B5).withOpacity(0.7),
                        )
                    ),
                  ),
              hintText: "Search",

              hintStyle: TextStyle(
                  fontSize: 16.0
              ),
              border: InputBorder.none),
        ),
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
    setState((){
      userId = loginResponse?.data?.userId ?? '';
    });
    Map<String, String> body = {
      Constants.PARAM_TO_USERID:  userId,
    };
    BlocProvider.of<ChatUsersBloc>(context).add(ChatUsersEvent(body: body));
  }

  void _getNotificationData() async {
    String? sponsorImg = await ApiProvider.instance.getSponserLink();
    bool? flagName = await ApiProvider.instance.getShowBadge();
    setState(() {
      sponsorImgUrl= sponsorImg ?? "";
      flag = flagName ?? false;
    });
  }

  // getSearchList()  {
  //   var searchName = _searchController.text.trim().toString();
  //   ChatUsers.Data searchList;
  //   for(int i=0; i>chatUserData.length; i++){
  //     if(chatUserData[i].name.toLowerCase().contains(searchName.toLowerCase())){
  //       searchChatUserData.add(chatUserData[i]);
  //     }
  //   }
  // }

  Future<bool> _onBackPressed() async {
    Navigator.pop(context,true);
    return true;
  }

  void onPressed() {
    if(_searchController.text.length > 1)
    fetchData();
    _searchController.clear();
  }

  @override
  void dispose() {
    _searchController.dispose();
  }
}
