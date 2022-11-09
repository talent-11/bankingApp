import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class FcmService {
  late final FirebaseMessaging _fcm;

  FcmService(this._fcm);

  void registerNotification() async {
    // 1. Initialize the Firebase app
    await Firebase.initializeApp();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 2. Instantiate Firebase Messaging
    _fcm = FirebaseMessaging.instance;

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      // TODO: handle the received notifications
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
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }



  Future initialise() async {
    if (Platform.isIOS) {
      // _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    // If you want to test the push notification locally,
    // you need to get the token and input to the Firebase console
    // https://console.firebase.google.com/project/YOUR_PROJECT_ID/notification/compose
    String? token = await _fcm.getToken();
    print("FirebaseMessaging token: $token");
  }
}

class PushNotification {
  PushNotification({
    this.title,
    this.body,
  });
  String? title;
  String? body;
}
