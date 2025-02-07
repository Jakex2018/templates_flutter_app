import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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