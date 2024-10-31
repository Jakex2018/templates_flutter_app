import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/screens/suscription/model/user_model.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeService() async {
  const InitializationSettings initializeSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializeSettings,
  );
}

Future<void> showrNotificacions(context) async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails('3213', 'show');

  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);
  final authProvider = Provider.of<AuthUserProvider>(context,
      listen: false); // Avoid unnecessary rebuilds

  final userId = authProvider.userId;

  // Fetch username from Firestore (assuming username is stored in 'users' collection)
  final usersCollection = FirebaseFirestore.instance.collection('users');
  final userDoc = await usersCollection.doc(userId).get();

  final username = userDoc.data()!['username'];

  await flutterLocalNotificationsPlugin.show(
      1,
      payload: '/suscription',
      '¡Hola $username,Tu suscripción ha expirado!',
      'Renueva tu suscripción para seguir disfrutando de nuestras funciones.',
      notificationDetails);
}

late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;



/*
const int notificationId = 13123;
const String notificationChannelId = '099';
void onStart(ServiceInstance service) async {
  flutterLocalNotificationsPlugin.show(
    notificationId,
    payload: '/suscription',
    '¡Hola,Tu suscripción ha expirado!',
    'Renueva tu suscripción para seguir disfrutando de nuestras funciones.',
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'your_foreground',
        'MY FOREGROUND SERVICE',
      ),
    ),
  );
}

Future<void> initializeService(context) async {
  //OBTENER METODOS
  final service = FlutterBackgroundService();

  //OBTENER DATOS DE USER Y SUSCRIPTIONS
  final authProvider = Provider.of<AuthUserProvider>(context, listen: false);
  final suscriptionProvider =
      Provider.of<SuscriptionProvider>(context, listen: false);
  final userData = await authProvider.getUserData();
  final username = userData.username;

  //SAVE DATA
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('username', username!);
  await prefs.setBool('isSubscribed', suscriptionProvider.isSuscribed);
  await prefs.setBool('isLogged', authProvider.isLogged);

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    iosConfiguration: IosConfiguration(),
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      foregroundServiceNotificationId: notificationId,
    ),
  );
}

 */