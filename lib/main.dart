import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pce/models/speakers/speakers_model.dart' as SpeakerResponse;
import 'package:pce/models/QrCode/QrCodeDetails.dart' as QrCodeDetails;
import 'package:pce/models/delegates/delegates_responce_entity.dart' as DelegatesResponseEntity;
import 'package:pce/models/notification/all_notification_response.dart' as AllNotificationResponse;
import 'package:pce/models/login/LoginResponse.dart';
import 'package:pce/models/screen_arguments.dart';
import 'package:pce/models/user_events/user_events.dart' as UserEvents;
import 'package:pce/network/api_provider.dart';
import 'package:pce/screens/agenda/agenda_bloc.dart';
import 'package:pce/screens/agenda/agenda_screen.dart';
import 'package:pce/screens/chats/chat_bloc.dart';
import 'package:pce/screens/chats/chats_screen.dart';
import 'package:pce/screens/chats/message_bloc.dart';
import 'package:pce/screens/chats/single_chat_screen.dart';
import 'package:pce/screens/chats/user_chat_screen.dart';
import 'package:pce/screens/contactus/contactus_screen.dart';
import 'package:pce/screens/dashboard/dashboard_bloc.dart';
import 'package:pce/screens/dashboard/dashboard_screen.dart';
import 'package:pce/screens/delegates/delegates_bloc.dart';
import 'package:pce/screens/delegates/delegates_screen.dart';
import 'package:pce/screens/image_open/image_open.dart';
import 'package:pce/screens/login/login_bloc.dart';
import 'package:pce/screens/login/login_screen.dart';
import 'package:pce/screens/map/map_screen.dart';
import 'package:pce/screens/notifications/notification_bloc.dart';
import 'package:pce/screens/notifications/notifications_screen.dart';
import 'package:pce/screens/partners/partners_bloc.dart';
import 'package:pce/screens/partners/partners_screen.dart';
import 'package:pce/screens/qr/qr_bloc.dart';
import 'package:pce/screens/qr/qr_screen.dart';
import 'package:pce/screens/select_event/fcm_update_bloc.dart';
import 'package:pce/screens/select_event/select_event_screen.dart';
import 'package:pce/screens/speakers/speakers_bloc.dart';
import 'package:pce/screens/speakers/speakers_screen.dart';
import 'package:pce/screens/splash/splash_bloc.dart';
import 'package:pce/screens/splash/splash_screen.dart';
import 'package:pce/screens/user/edit_profile.dart';
import 'package:pce/screens/user/get_country_bloc.dart';
import 'package:pce/screens/user/my_profile.dart';
import 'package:pce/screens/user/my_profile_bloc.dart';
import 'package:pce/screens/user/other_user/other_screen.dart';
import 'package:pce/screens/user/other_user/send_msg_bloc.dart';
import 'package:pce/screens/user/user_screen.dart';
import 'package:pce/screens/venue/venue_screen.dart';
import 'package:pce/screens/webview/webview_screen.dart';
import 'package:pce/utils/constants.dart' as Constants;
import 'package:pce/utils/custom_route.dart';
import 'package:pce/utils/navigator_service.dart';
import 'package:pce/utils/simple_bloc_delegate.dart';
import 'package:pce/utils/singleton.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Controllers/socket_controller.dart';
import 'models/chat/get_chat_users_response.dart' as UserChatResponse;


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
BehaviorSubject<ReceivedNotification>();
/// A notification action which triggers a url launch event
const String urlLaunchActionId = 'id_1';

/// A notification action which triggers a App navigation event
const String navigationActionId = 'id_3';
const String darwinNotificationCategoryPlain = 'plainCategory';
const String darwinNotificationCategoryText = 'textCategory';
final List<DarwinNotificationCategory> darwinNotificationCategories =
<DarwinNotificationCategory>[
  DarwinNotificationCategory(
    darwinNotificationCategoryText,
    actions: <DarwinNotificationAction>[
      DarwinNotificationAction.text(
        'text_1',
        'Action 1',
        buttonTitle: 'Send',
        placeholder: 'Placeholder',
      ),
    ],
  ),
  DarwinNotificationCategory(
    darwinNotificationCategoryPlain,
    actions: <DarwinNotificationAction>[
      DarwinNotificationAction.plain('id_1', 'Action 1'),
      DarwinNotificationAction.plain(
        'id_2',
        'Action 2 (destructive)',
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.destructive,
        },
      ),
      DarwinNotificationAction.plain(
        navigationActionId,
        'Action 3 (foreground)',
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.foreground,
        },
      ),
      DarwinNotificationAction.plain(
        'id_4',
        'Action 4 (auth required)',
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.authenticationRequired,
        },
      ),
    ],
    options: <DarwinNotificationCategoryOption>{
      DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
    },
  )
];
class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}
final DarwinInitializationSettings initializationSettingsDarwin =
DarwinInitializationSettings(
  requestAlertPermission: false,
  requestBadgePermission: false,
  requestSoundPermission: false,
  onDidReceiveLocalNotification:
      (int id, String? title, String? body, String? payload) async {
    didReceiveLocalNotificationSubject.add(
      ReceivedNotification(
        id: id,
        title: title,
        body: body,
        payload: payload,
      ),
    );
  },
  notificationCategories: darwinNotificationCategories,
);
var androidSettings = AndroidInitializationSettings('@drawable/ic_logo');
var initSetttings = InitializationSettings(android: androidSettings, iOS: initializationSettingsDarwin);
int notificationId = 1;
var notificationNameTag = '';
var notificationTitle = "Projects control expo";
var notificationMsg = '';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
Future<void> main() async {
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await notificationPermission();
  await Firebase.initializeApp();
  await getFCMDeviceToken();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //await setupInteractedMessage();
  FirebaseMessaging.onMessage.listen(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

  flutterLocalNotificationsPlugin.initialize(initSetttings);

  // flutterLocalNotificationsPlugin.initialize(initSetttings,
  //     onSelectNotification: onSelectNotification);
  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  BlocOverrides.runZoned(
        () => runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<SplashBloc>(
            create: (context) => SplashBloc(),
          ),
          BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(),
          ),
          BlocProvider<AgendaBloc>(
            create: (context) => AgendaBloc(),
          ),
          BlocProvider<DelegatesBloc>(
            create: (context) => DelegatesBloc(),
          ),
          BlocProvider<QrBloc>(
            create: (context) => QrBloc(),
          ),
          BlocProvider<SendMsgBloc>(
            create: (context) => SendMsgBloc(),
          ),
          BlocProvider<MyProfileBloc>(
            create: (context) => MyProfileBloc(),
          ),
          BlocProvider<CountryBloc>(
            create: (context) => CountryBloc(),
          ),
          BlocProvider<PartnersBloc>(
            create: (context) => PartnersBloc(),
          ),
          BlocProvider<SpeakersBloc>(
            create: (context) => SpeakersBloc(),
          ),
          BlocProvider<AllNotificationBloc>(
            create: (context) => AllNotificationBloc(),
          ),
          BlocProvider<FcmUpdateBloc>(
            create: (context) => FcmUpdateBloc(),
          ),
          BlocProvider<DashboardBloc>(
            create: (context) => DashboardBloc(),
          ),
          BlocProvider<ChatUsersBloc>(
            create: (context) => ChatUsersBloc(),
          ),
          BlocProvider<MessageBloc>(
            create: (context) => MessageBloc(),
          ),
          Provider<SocketController>(
            create: (context) => SocketController(),
          ),
        ],
        child: const MyApp(),
      ),
    ),
    blocObserver: SimpleBlocDelegate(),
  );

}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Main : _firebaseMessagingBackgroundHandler: ${message.data}");
  _showiDirectNotification(message.data);
}
// Future<void> setupInteractedMessage() async {
//   // Get any messages which caused the application to open from
//   // a terminated state.
//   RemoteMessage? initialMessage =
//   await FirebaseMessaging.instance.getInitialMessage();
//
//   // If the message also contains a data property with a "type" of "chat",
//   // navigate to a chat screen
//   if (initialMessage != null) {
//     _handleBgMessage(initialMessage);
//   }
//
//   // Also handle any interaction when the app is in the background via a
//   // Stream listener
//   FirebaseMessaging.onMessageOpenedApp.listen(_handleBgMessage);
// }
Future<void> _handleMessage(RemoteMessage message) async {
  print("On click : Handling a background message: ${message.data}");
  var payload = message.data['message'];
  if (payload.data['type'] == 'noti') {
    print('local notification was clicked $payload');
    MaterialPageRoute(
      builder: (BuildContext context) => const NotificationsScreen(),
    );
  }else{
    print('local notification was clicked $payload');
    MaterialPageRoute(
      builder: (BuildContext context) => const NotificationsScreen(),
    );
  }
}
void _handleBgMessage(RemoteMessage payload) {
  print('_handleBgMessage was clicked $payload');
  if (payload.data['type'] == 'noti') {
    print('local notification was clicked $payload');
    MaterialPageRoute(
      builder: (BuildContext context) => const NotificationsScreen(),
    );
  }
}
Future<void> _showiDirectNotification(Map<String, dynamic> data) async {
  print('_showiDirectNotification');
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
      'pce_notification_channel',
      'PCEChannelName',
      channelDescription: 'Project Control Expo Events',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      playSound: true,
      largeIcon: DrawableResourceAndroidBitmap('@drawable/notificationnew'),
      channelShowBadge: true,
      styleInformation: BigTextStyleInformation(''),
      icon: '@drawable/ic_logo'
  );
  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);

  var payload = data['body'];
  notificationTitle = data['title'];
  notificationMsg = data['body'];
  await flutterLocalNotificationsPlugin.show(
    notificationId,
    notificationTitle,
    notificationMsg,
    platformChannelSpecifics,
    payload: payload,
  );
  ApiProvider.instance.setShowBadge(true);
}

Future<void> getFCMDeviceToken() async {
  try {
    String? fcmDeviceToken = await FirebaseMessaging.instance.getToken();
    if(fcmDeviceToken != null){
      print('fcmDeviceToken - $fcmDeviceToken');
      await ApiProvider.instance.setFcmToken(fcmDeviceToken);
    }else{
      print('fcmDeviceToken else- $fcmDeviceToken');
    }
  }catch (error){
    print('fcmDeviceToken error - $error');
  }

  String? fcm = await ApiProvider.instance.getFcmToken();
  print('SaveFCMToken - $fcm');
}
Future<void> notificationPermission() async {
  //for sdk version 33/ android 13 or above, it's required to ask notification permission, by default notification permission blocked in android 13 or above
  if(Platform.isAndroid){
    if (((!await Permission.notification.isGranted) || await Permission.notification.isDenied)) {
      await Permission.notification.request();
    }
  }
}

class MyApp extends StatefulWidget {
  final Locale? locale;

  const MyApp({Key? key, this.locale}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (context, child) {
        return MaterialApp(
          navigatorKey: NavigationService.navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Skills Connect',
          initialRoute: Constants.ROUTE_ROOT,
          supportedLocales: const [Locale('en', 'US')],
          theme: ThemeData(
            // Define the default brightness and colors.
            brightness: Brightness.light,
            unselectedWidgetColor: Colors.white,
            primaryColor: AppSingleton.instance.getPrimaryColor(),
          ),
          onGenerateRoute: (RouteSettings settings) {
            final arguments = settings.arguments;
            Constants.current_route = settings.name!;

            switch (settings.name) {
              case Constants.ROUTE_ROOT:
                return CustomRoute(
                  builder: (_) => const SplashScreen(),
                  settings: settings,
                );
              case Constants.ROUTE_LOGIN:
                return CustomRoute(
                  builder: (_) => const LoginScreen(),
                  settings: settings,
                );
              case Constants.ROUTE_SELECT_EVENT:
                if (arguments is List<UserEvents.Data>) {
                  // the details page for one specific user
                  return CustomRoute(
                    builder: (_) =>  SelectEventScreen(data: arguments,),
                    settings: settings,
                  );
                }
                break;
              case Constants.ROUTE_DASHBOARD:
                return CustomRoute(
                  builder: (_) => const DashboardScreen(),
                  settings: settings,
                );
              case Constants.ROUTE_AGENDA:
                return CustomRoute(
                  builder: (_) => const AgendaScreen(),
                  settings: settings,
                );
              case Constants.ROUTE_MAP:
                if(arguments is ScreenArguments) {
                  return CustomRoute(
                    builder: (_) => MapScreen(mapUrl: arguments.url,directionUrl: arguments.name,),
                    settings: settings,
                  );
                }
                break;
              case Constants.ROUTE_VENUE:
                return CustomRoute(
                  builder: (_) => const VenueScreen(),
                  settings: settings,
                );
              case Constants.ROUTE_DELEGATES:
                return CustomRoute(
                  builder: (_) => const DelegatesScreen(),
                  settings: settings,
                );
              case Constants.ROUTE_CHATS:
                return CustomRoute(
                  builder: (_) => const ChatsScreen(),
                  settings: settings,
                );
              case Constants.ROUTE_CHAT_MSG:
                return CustomRoute(
                  builder: (_) =>  SingleChatsScreen(),
                  settings: settings,
                );
              case Constants.ROUTE_USER_CHAT:
                if(arguments is UserChatResponse.Data) {
                  return CustomRoute(
                    builder: (_) => UserChatScreen(name: arguments.name, toUserId: arguments.id, toImageUrl: arguments.imageUrl,),
                    settings: settings,
                  );
                }if(arguments is DelegatesResponseEntity.Data){
                  return CustomRoute(
                    builder: (_) => UserChatScreen(name: arguments.name, toUserId: arguments.id,toImageUrl: arguments.headshot,),
                    settings: settings,
                  );
                }else if(arguments is AllNotificationResponse.Data){
                  return CustomRoute(
                    builder: (_) => UserChatScreen(name: arguments.name, toUserId: arguments.fromUserId,toImageUrl: arguments.headshot,),
                    settings: settings,
                  );
                }else if(arguments is SpeakerResponse.Data){
                  return CustomRoute(
                    builder: (_) => UserChatScreen(name: arguments.name, toUserId: arguments.id,toImageUrl: arguments.headshot,),
                    settings: settings,
                  );
                }
               break;
              case Constants.ROUTE_PARTNERS:
                return CustomRoute(
                  builder: (_) => const PartnersScreen(),
                  settings: settings,
                );
              case Constants.ROUTE_SPEAKERS:
                return CustomRoute(
                  builder: (_) => const SpeakersScreen(),
                  settings: settings,
                );
              case Constants.ROUTE_QR:
                return CustomRoute(
                  builder: (_) => const QrScreen(),
                  settings: settings,
                );
              case Constants.ROUTE_CONTACTUS:
                return CustomRoute(
                  builder: (_) => const ContactUsScreen(),
                  settings: settings,
                );
              case Constants.ROUTE_USER:
                return CustomRoute(
                  builder: (_) => const UserScreen(),
                  settings: settings,
                );
              case Constants.ROUTE_NOTIFICATIONS:
                return CustomRoute(
                  builder: (_) => const NotificationsScreen(),
                  settings: settings,
                );
              case Constants.ROUTE_MY_PROFILE:
                return CustomRoute(
                  builder: (_) => const MyProfileScreen(),
                  settings: settings,
                );
              case Constants.ROUTE_EDIT_PROFILE:
                return CustomRoute(
                  builder: (_) => const EditProfile(),
                  settings: settings,
                );
              case Constants.ROUTE_IMAGE_OPEN:
                if(arguments is ScreenArguments) {
                  return CustomRoute(
                    builder: (_) => ImageOpen(imageUrl: arguments.url,),
                    settings: settings,
                  );
                }
                break;
              case Constants.ROUTE_WEBVIEW:
                if(arguments is ScreenArguments){
                  return CustomRoute(
                    builder: (_) =>  WebviewScreen(webviewUrl: arguments.url,title: arguments.name,),
                    settings: settings,
                  );
                }
                break;
              case Constants.ROUTE_OTHER_USER:
                if (arguments is QrCodeDetails.Data) {
                  // the details page for one specific user
                  return CustomRoute(
                    builder: (_) => OtherUserScreen(response: arguments,flag: 0,),
                    settings: settings,
                  );
                }else if(arguments is DelegatesResponseEntity.Data){
                  return CustomRoute(
                    builder: (_) => OtherUserScreen(response: arguments,flag: 1,),
                    settings: settings,
                  );
                }else if(arguments is AllNotificationResponse.Data){
                  return CustomRoute(
                    builder: (_) => OtherUserScreen(response: arguments,flag: 1,),
                    settings: settings,
                  );
                }else if(arguments is AllNotificationResponse.Data){
                  return CustomRoute(
                    builder: (_) => OtherUserScreen(response: arguments,flag: 1,),
                    settings: settings,
                  );
                }else if(arguments is SpeakerResponse.Data){
                  return CustomRoute(
                    builder: (_) => OtherUserScreen(response: arguments,flag: 2,),
                    settings: settings,
                  );
                }

                break;
              default:
                return CustomRoute(
                  builder: (_) => const LoginScreen(),
                  settings: settings,
                );
            }
          },
          onUnknownRoute: (RouteSettings settings) {
            return MaterialPageRoute(
              builder: (BuildContext context) => const LoginScreen(),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    super.dispose();
  }
}


