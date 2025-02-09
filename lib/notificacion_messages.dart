import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/common/back_services.dart';
import 'package:templates_flutter_app/screens/suscription/model/user_model.dart';

class NotificacionMessages {
  static Future<void> requestPermissionLocalNotifications() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> initializeLocalNotifications() async {
    final flutterLocalnotificationsPlugin = FlutterLocalNotificationsPlugin();
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationsSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalnotificationsPlugin.initialize(initializationsSettings);
  }
}

Future<void> sendNotification() async {
  try {
    final token =
        "d9u8sTQnSfiiEyqxcV_02i:APA91bHSy-lN3M8wB2FA8xn-NXy6wA8O1GrFmI2lcQy_MaRh17vNkGAiZ0fedWAEGlEHbf9P2Lg1Jn0x0FxMp0O95BBGwyOZpVmm9N5wyhhLuUckmPbXx03LRC_QVgxniHuvDsEaMjzr";

    final response = await http.post(
      Uri.parse('https://fcmtemplate-app.onrender.com'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "token": token,
        "title": "¡Tu suscripción ha expirado!",
        "body":
            "Renueva tu suscripción para seguir disfrutando de nuestras funciones."
      }),
    );

    if (response.statusCode == 200) {
      print('Notificación enviada con éxito');
    } else {
      print('Error al enviar notificación: ${response.body}');
    }
  } catch (e) {
    print('Error en la solicitud HTTP: $e');
  }
}

Future<void> showNotification(
    String title, String body, BuildContext context) async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails('3213', 'show');
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);

  final authProvider = Provider.of<AuthUserProvider>(context, listen: false);
  final userId = authProvider.userId;

  final usersCollection = FirebaseFirestore.instance.collection('users');
  final userDoc = await usersCollection.doc(userId).get();
  final username = userDoc.data()!['username'];

  await flutterLocalNotificationsPlugin.show(
    1,
    '¡Hola $username, $title',
    body,
    notificationDetails,
    payload: '/suscription',
  );
}


/*
import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/screens/suscription/model/user_model.dart';
import 'package:templates_flutter_app/screens/suscription/suscription_screen.dart';
import 'package:http/http.dart' as http;

class NotificacionMessages {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Inicializa notificaciones locales y permisos
  Future<void> requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  // Inicialización de notificaciones locales
  Future<void> initializeNotification(BuildContext context) async {
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;
        if (payload != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SuscriptionScreen(),
            ),
          );
        }
      },
    );

    final token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');

    // Escucha mensajes en primer plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Aquí puedes manejar el mensaje que llega en primer plano
      print('Notificación recibida en primer plano: ${message.messageId}');
      showNotification(
        message.notification?.title ?? 'Notificación',
        message.notification?.body ?? 'Mensaje de notificación',
        context,
      );
    });
  }

  Future<void> backgroundHandler(RemoteMessage message) async {
    print('Notificación recibida en segundo plano: ${message.messageId}');
    await sendNotification();
  }

  // Muestra la notificación local
  Future<void> showNotification(
      String title, String body, BuildContext context) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('3213', 'show');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    final authProvider = Provider.of<AuthUserProvider>(context, listen: false);
    final userId = authProvider.userId;

    final usersCollection = FirebaseFirestore.instance.collection('users');
    final userDoc = await usersCollection.doc(userId).get();
    final username = userDoc.data()!['username'];

    await flutterLocalNotificationsPlugin.show(
      1,
      '¡Hola $username, $title',
      body,
      notificationDetails,
      payload: '/suscription',
    );
  }

  // Función para enviar una notificación manualmente
  Future<void> sendNotification() async {
    try {
      final token =
          "d9u8sTQnSfiiEyqxcV_02i:APA91bHSy-lN3M8wB2FA8xn-NXy6wA8O1GrFmI2lcQy_MaRh17vNkGAiZ0fedWAEGlEHbf9P2Lg1Jn0x0FxMp0O95BBGwyOZpVmm9N5wyhhLuUckmPbXx03LRC_QVgxniHuvDsEaMjzr";

      final response = await http.post(
        Uri.parse('https://fcmtemplate-app.onrender.com'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "token": token,
          "title": "¡Tu suscripción ha expirado!",
          "body":
              "Renueva tu suscripción para seguir disfrutando de nuestras funciones."
        }),
      );

      if (response.statusCode == 200) {
        print('Notificación enviada con éxito');
      } else {
        print('Error al enviar notificación: ${response.body}');
      }
    } catch (e) {
      print('Error en la solicitud HTTP: $e');
    }
  }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();


 */