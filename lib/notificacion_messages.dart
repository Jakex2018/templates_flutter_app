// ignore_for_file: avoid_print

import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:templates_flutter_app/screens/suscription/suscription_screen.dart';

class NotificacionMessages {
  final notify = FirebaseMessaging.instance;
  static final StreamController _messageStream = StreamController.broadcast();

  static Stream get messageStream => _messageStream.stream;
  static Future _backgroundHandler(RemoteMessage message) async {
    print('Background ${message.messageId}');
    _messageStream.add(message.notification?.title ?? 'no Title');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    print('On Message ${message.messageId}');
    _messageStream.add(message.notification?.title ?? 'no Title');
  }

  Future<void> initializeNotification(BuildContext context) async {
    ///await Firebase.initializeApp();
    final token = await notify.getToken();
    print('Token: $token');
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Extract data from the notification payload for potential routing logic
      final data = message.data;

      // Example: Navigate to SubscriptionScreen based on data in the notification
      if (data.containsKey('action') && data['action'] == 'goToSubscription') {
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => const SuscriptionScreen(),
          ),
        ); // Replace with your route name
      } else {
        // Handle other notification actions or display a generic notification screen
        _messageStream.add(message.notification?.title ?? 'no Title');
      }
    });
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
  }

  static closeStream() {
    _messageStream.close();
  }
}

/*
class NotificacionMessages {
  final notify = FirebaseMessaging.instance;
  static final StreamController _messageStream = StreamController.broadcast();

  static Stream get messageStream => _messageStream.stream;
  static Future _backgroundHandler(RemoteMessage message) async {
    print('Background ${message.messageId}');
    _messageStream.add(message.notification?.title ?? 'no Title');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    print('On Message ${message.messageId}');
    _messageStream.add(message.notification?.title ?? 'no Title');
  }

  static Future _onOpenMessage(RemoteMessage message) async {
    print('On MessageOpenApp ${message.messageId}');
    _messageStream.add(message.notification?.title ?? 'no Title');
  }

  Future<void> initializeNotification() async {
    ///await Firebase.initializeApp();
    final token = await notify.getToken();
    print('Token: $token');

    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onOpenMessage);
  }

  static closeStream() {
    _messageStream.close();
  }
}

 */


/*
Future<void> handleBg(RemoteMessage? message) async {
  if (message != null) {
    print(message);
  }
}

class NotificacionMessages {
  final notify = FirebaseMessaging.instance;
  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'notification', 'notification',
      importance: Importance.max, playSound: true, showBadge: true);
  final localNotification = FlutterLocalNotificationsPlugin();

  Future<void> initializeNotification() async {
    NotificationSettings settings = await notify.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print('PERMISSION DENIED');
    }

    if (FirebaseAuth.instance.currentUser != null) {
      final fcmToken = await notify.getToken();
      print('TOKEN $fcmToken');
    }

    FirebaseMessaging.onBackgroundMessage(handleBg);
    initPushNotification();
  }
}

Future<void> initPushNotification() async {
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
}

void handleMessage(RemoteMessage? message) {
  if (message != null) {
    print(message);
  }
}

void subscribeTopic() {
  FirebaseMessaging.instance.subscribeToTopic('notification');
}





 */