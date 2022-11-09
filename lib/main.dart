import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import 'package:fotoc/providers/account_provider.dart';
import 'package:fotoc/routes.dart';
import 'package:fotoc/services/fcm_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CurrentAccount>(create: (_) => CurrentAccount()),
      ],
      child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }

  void registerNotification(BuildContext context) async {
    // 1. Initialize the Firebase app
    await Firebase.initializeApp();

    // 2. Instantiate Firebase Messaging
    FirebaseMessaging fcm = FirebaseMessaging.instance;

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await fcm.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    
    String? token = await fcm.getToken();
    context.read<CurrentAccount>().setFcmToken(token!);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // print('User granted permission');
      
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Parse the message received
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );
        showSimpleNotification(
          Text(notification.title!),
          position: NotificationPosition.top,
        );
      });

      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        print('Message clicked!');
      });

      // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    } else {
      print('User declined or has not accepted permission');
    }
  }

  @override
  Widget build(BuildContext context) {
    registerNotification(context);

    return OverlaySupport(
      child: MaterialApp(
        title: 'FOTOC',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // brightness: Brightness.dark,
          primaryColor: const Color(0xff5d10f6),
          fontFamily: 'Roboto',
          // primarySwatch: Colors.blue,
          textTheme: const TextTheme(
            headline1: TextStyle(fontSize: 20.0, color: Color(0xff252631), fontWeight: FontWeight.w400),
            headline4: TextStyle(fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.w500),
            headline5: TextStyle(fontSize: 15.0, height: 1.4, color: Color(0xff252631), fontWeight: FontWeight.w400),
            headline6: TextStyle(fontSize: 14.0, color: Color(0xff252631), fontWeight: FontWeight.w500),
            bodyText1: TextStyle(fontSize: 14.0, color: Color(0xff98a9bc), height: 1.4),
            bodyText2: TextStyle(fontSize: 12.0, color: Color(0xff98a9bc), height: 1.2),
          ),
          textSelectionTheme: const TextSelectionThemeData(cursorColor: Color(0xff5d10f6)),
        ),
        // home: const SignupPage(),
        routes: routes,
      )
    );
  }
}
