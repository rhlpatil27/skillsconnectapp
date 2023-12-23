import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pce/Controllers/socket_controller.dart';
import 'package:pce/base_widgets/app_textstyle.dart';
import 'package:pce/models/chat/get_user_messages_response.dart';
import 'package:pce/models/delegates/delegates_responce_entity.dart';
import 'package:pce/models/subscription_models.dart';
import 'package:pce/network/api_provider.dart';
import 'package:pce/screens/delegates/delegates_bloc.dart';
import 'package:pce/utils/advanced_text_field.dart';
import 'package:pce/utils/chat_bubble.dart';
import 'package:pce/utils/constants.dart' as Constants;

import '../../models/events.dart';
import '../../utils/singleton.dart';

class SingleChatsScreen extends StatefulWidget {
  const SingleChatsScreen({Key? key}) : super(key: key);

  @override
  _SingleChatsScreenState createState() => _SingleChatsScreenState();
}

class _SingleChatsScreenState extends State<SingleChatsScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GetUserMessagesResponse response = GetUserMessagesResponse();
  String dayTitle = '';
  String filter = '';
  String filter2 = '';
  final TextEditingController name = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  bool flag = false;
  bool isSubscribe = false;
  String sponsorImgUrl= '';

  // List conversationList = [
  //   {
  //     "name": "Novac",
  //     "imageUrl": "https://pceuat.convstaging.com/assets/user_assets/custom/img/sample.jpg",
  //     "isSelf": true,
  //     "message": "Where are you?",
  //     "time": "5:00 pm"
  //   },
  //   {
  //     "name": "Derick",
  //     "imageUrl": "https://pceuat.convstaging.com/assets/user_assets/custom/img/sample.jpg",
  //     "isSelf": false,
  //     "message": "It's good!!",
  //     "time": "7:00 am"
  //   },
  //   {
  //     "name": "Mevis",
  //     "imageUrl": "https://pceuat.convstaging.com/assets/user_assets/custom/img/sample.jpg",
  //     "isSelf": false,
  //     "message": "I love You too!",
  //     "time": "6:50 am"
  //   },
  //   {
  //     "name": "Emannual",
  //     "imageUrl": "https://pceuat.convstaging.com/assets/user_assets/custom/img/sample.jpg",
  //     "isSelf": true,
  //     "message": "Got to go!! Bye!!",
  //     "time": "yesterday"
  //   },
  //   {
  //     "name": "Gracy",
  //     "imageUrl": "https://pceuat.convstaging.com/assets/user_assets/custom/img/sample.jpg",
  //     "isSelf": false,
  //     "message": "Sorry, I forgot!",
  //     "time": "2nd Feb"
  //   },
  //   {
  //     "name": "Robert",
  //     "imageUrl": "https://pceuat.convstaging.com/assets/user_assets/custom/img/sample.jpg",
  //     "isSelf": true,
  //     "message": "No, I won't go!",
  //     "time": "28th Jan"
  //   },
  //
  // ];
  SocketController? _socketController;
  late final TextEditingController _textEditingController;

  bool _isTextFieldHasContentYet = false;
  @override
  void initState() {
    super.initState();
    // fetchData();
    _getNotificationData();
    _textEditingController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //Initilizing and connecting to the socket
      SocketController.get(context)
        ..init()
        ..connect(
          onConnectionError: (data) {
            print(data);
          },
        );
      _socketController = SocketController.get(context);

      //Start listening to the text editing controller
      _textEditingController.addListener(() {
        final _text = _textEditingController.text.trim();
        if (_text.isEmpty) {
          _socketController!.stopTyping();
          _isTextFieldHasContentYet = false;
        } else {
          if (_isTextFieldHasContentYet) return;
          _socketController!.typing();
          _isTextFieldHasContentYet = true;
        }
      });

      setState(() {});
    });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _socketController = SocketController.get(context);
    //
    //   //Start listening to the text editing controller
    //   _textEditingController.addListener(() {
    //     final _text = _textEditingController.text.trim();
    //     if (_text.isEmpty) {
    //       _socketController!.stopTyping();
    //       _isTextFieldHasContentYet = false;
    //     } else {
    //       if (_isTextFieldHasContentYet) return;
    //       _socketController!.typing();
    //       _isTextFieldHasContentYet = true;
    //     }
    //   });
    //
    //   setState(() {});
    // });

  }
  @override
  void dispose() {
    _socketController!.unsubscribe();
    _textEditingController.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) => SocketController.get(context).dispose());
    super.dispose();
  }
  void _sendMessage() {
    var subscription = Subscription(
      roomName: "Test",
      userName: "Rahul",
    );
   if(!isSubscribe){
     // Subscribe and go the Chat screen
     SocketController.get(context).subscribe(
       subscription,
       onSubscribe: () {
         isSubscribe = true;
         // Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen()));
       },
     );
   }
    if(isSubscribe){
      if (_textEditingController.text.isEmpty) return;
      final _message = Message(messageContent: _textEditingController.text);
      // _socketController?.sendMessage(_message);
      _textEditingController.clear();
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        drawerEdgeDragWidth: 0,
        backgroundColor: AppSingleton.instance.getBackgroundColor(),
        appBar: AppSingleton.instance.buildAppBar(context, badgeFlag: flag),
        body: Stack(
          children: [
            Positioned.fill(
              top: 0,
              bottom: null,
              child: Container(
                color: AppSingleton.instance.getBackgroundColor(),
                child: AppSingleton.instance.buildToolbar(
                    context,
                    'Chats',
                    null,
                    flag
                ),
              ),
            ),
            Positioned.fill(
              child: StreamBuilder<List<ChatEvent>>(
                  stream: _socketController?.watchEvents,
                  initialData: [],
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Center(child: CircularProgressIndicator.adaptive());
                    final _events = snapshot.data!;
                    if (_events.isEmpty) return Center(child: Text("Start sending..."));
                    return ListView.separated(
                      reverse: true,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0).add(
                        const EdgeInsets.only(bottom: 70.0),
                      ),
                      itemCount: _events.length,
                      separatorBuilder: (context, index) => SizedBox(height: 5.0),
                      itemBuilder: (context, index) {
                        final _event = _events[index];
                        //? If the event is a new message
                        if (_event is Message) {
                          //TODO: Determin the type of the message user by using user's socket_id not his name.
                          return TextBubble(
                            message: _event,
                            type: _event.userName == _socketController!.subscription!.userName
                                ? BubbleType.sendBubble
                                : BubbleType.receiverBubble,
                          );
                          //? If a user entered or left the room
                        } else if (_event is ChatUser) {
                          //? The user has left the current room
                          if (_event.userEvent == ChatUserEvent.left) {
                            return Center(child: Text("${_event.userName} left"));
                          }
                          //? The user has joined a new room
                          return Center(child: Text("${_event.userName} has joined"));

                          //? A user started typing event
                        } else if (_event is UserStartedTyping) {
                          return UserTypingBubble();
                        }
                        return SizedBox();
                      },
                    );
                  }),
            ),
            Positioned.fill(
              top: null,
              bottom: 0,
              child: Container(
                color: Colors.white,
                child: Row(
                  children: [
                    SizedBox(width: 20),
                    Expanded(
                      child: AdvancedTextField(
                        controller: _textEditingController,
                        hintText: "Type your message...",
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      onPressed: () => _sendMessage(),
                      icon: Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Widget buildSignInScreen() {
  //   return BlocConsumer(
  //     bloc: BlocProvider.of<DelegatesBloc>(context),
  //     listener: (context, state) {
  //       if (state is DelegatesError) {
  //         _showError(state.error);
  //       }
  //     },
  //     builder: (context, state) {
  //       if (state is DelegatesLoaded) {
  //         responce = state.response;
  //         // var responce = state.response.data;
  //         return buildSignInScreen1(responce);
  //       }
  //       return AppSingleton.instance.buildCenterSizedProgressBar();
  //     },
  //   );
  // }

  Widget buildSignInScreen() {
    return Container(
      color: AppSingleton.instance.getBackgroundColor(),
      child: Expanded(
        child: Column(
          children: [
            AppSingleton.instance.buildToolbar(
              context,
              'Chats',
                null,
                flag
            ),
            // Stack(
            //   children: [
            //     Positioned.fill(
            //       child: StreamBuilder<List<ChatEvent>>(
            //           stream: _socketController?.watchEvents,
            //           initialData: [],
            //           builder: (context, snapshot) {
            //             if (!snapshot.hasData) return Center(child: CircularProgressIndicator.adaptive());
            //             final _events = snapshot.data!;
            //             if (_events.isEmpty) return Center(child: Text("Start sending..."));
            //             return ListView.separated(
            //               reverse: true,
            //               padding: const EdgeInsets.symmetric(horizontal: 20.0).add(
            //                 const EdgeInsets.only(bottom: 70.0),
            //               ),
            //               itemCount: _events.length,
            //               separatorBuilder: (context, index) => SizedBox(height: 5.0),
            //               itemBuilder: (context, index) {
            //                 final _event = _events[index];
            //                 //? If the event is a new message
            //                 if (_event is Message) {
            //                   //TODO: Determin the type of the message user by using user's socket_id not his name.
            //                   return TextBubble(
            //                     message: _event,
            //                     type: _event.userName == _socketController!.subscription!.userName
            //                         ? BubbleType.sendBubble
            //                         : BubbleType.receiverBubble,
            //                   );
            //                   //? If a user entered or left the room
            //                 } else if (_event is ChatUser) {
            //                   //? The user has left the current room
            //                   if (_event.userEvent == ChatUserEvent.left) {
            //                     return Center(child: Text("${_event.userName} left"));
            //                   }
            //                   //? The user has joined a new room
            //                   return Center(child: Text("${_event.userName} has joined"));
            //
            //                   //? A user started typing event
            //                 } else if (_event is UserStartedTyping) {
            //                   return UserTypingBubble();
            //                 }
            //                 return SizedBox();
            //               },
            //             );
            //           }),
            //     ),
            //     Positioned.fill(
            //       top: null,
            //       bottom: 0,
            //       child: Container(
            //         color: Colors.white,
            //         child: Row(
            //           children: [
            //             SizedBox(width: 20),
            //             Expanded(
            //               child: AdvancedTextField(
            //                 controller: _textEditingController,
            //                 hintText: "Type your message...",
            //                 onSubmitted: (_) => _sendMessage(),
            //               ),
            //             ),
            //             SizedBox(width: 10),
            //             IconButton(
            //               onPressed: () => _sendMessage(),
            //               icon: Icon(Icons.send),
            //             ),
            //           ],
            //         ),
            //       ),
            //     )
            //   ],
            // ),
            // if (responseEntity.data!.length > 0) ...[
            //   Expanded(
            //     child: ListView.builder(
            //         itemCount: responseEntity.data!.length,
            //         scrollDirection: Axis.vertical,
            //         itemBuilder: (BuildContext context, int index) {
            //           return Padding(
            //             padding:
            //                 EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            //             child: InkWell(
            //               onTap: () {
            //                 // Navigator.pushNamed(
            //                 //     context, Constants.ROUTE_USER);
            //                 Navigator.pushNamed(
            //                     context, Constants.ROUTE_OTHER_USER,
            //                     arguments: responseEntity.data![index]);
            //               },
            //               child: Card(
            //                 elevation: 5,
            //                 shape: RoundedRectangleBorder(
            //                   side: BorderSide(
            //                       color:
            //                           AppSingleton.instance.getSecondaryColor(),
            //                       width: 1.0),
            //                   borderRadius: BorderRadius.circular(10.0),
            //                 ),
            //                 child: ListTile(
            //                   leading: ClipRRect(
            //                     borderRadius: BorderRadius.circular(5.0),
            //                     child: Container(
            //                       height: 50.0,
            //                       width: 50.0,
            //                       child: Image.network(
            //                         responseEntity.data![index].headshot.toString(),
            //                         loadingBuilder: (BuildContext context,
            //                             Widget child,
            //                             ImageChunkEvent? loadingProgress) {
            //                           if (loadingProgress == null) return child;
            //                           return Center(
            //                               child: Container(
            //                                   height: 50.0,
            //                                   width: 50.0,
            //                                   color:
            //                                       Colors.grey.withOpacity(0.5)));
            //                         },
            //                         errorBuilder: (BuildContext? context, Object? exception, StackTrace? stackTrace) {
            //                           return Container(
            //                               height: 50,
            //                               width: 50,
            //                               child: Center(
            //                                 child: Text('No Image Available',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0),
            //                                 ),
            //                               ));
            //                         },
            //                       ),
            //                     ),
            //                   ),
            //                   // leading: getPhotos(imageUrl: responce.data![index].headshot.toString(),radius: 10,placeHolderImage: Container(height: 50.0,width: 50.0,color: Colors.grey.withOpacity(0.5),)),
            //                   title: Text(
            //                       "\n${responseEntity.data![index].firstName} ${responseEntity.data![index].lastName}"),
            //                   subtitle: Text(
            //                     "${responseEntity.data![index].company}",
            //                     maxLines: 3,
            //                   ),
            //                   isThreeLine: true,
            //                   dense: true,
            //                 ),
            //               ),
            //             ),
            //           );
            //         }),
            //   )
            // ] else ...[
            //   Text("No Delegates Available")
            // ],
            // _conversations(context),
            // AppSingleton.instance.bottomBar(context,sponsorImgUrl)
          ],
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
    String? eid = await ApiProvider.instance.getUserEventId();
    Map<String, String> body = {
      Constants.PARAM_EVENT_ID: eid ?? '',
    };
    BlocProvider.of<DelegatesBloc>(context).add(DelegatesEvent(body: body));
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
