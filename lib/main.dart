import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:templates_flutter_app/common/bloc_providers.dart';
import 'package:templates_flutter_app/common/routes/name.dart';
import 'package:templates_flutter_app/common/services/admob_services.dart';
import 'package:templates_flutter_app/common/services/intialize_app.dart';
import 'package:templates_flutter_app/global.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/themes/theme_provider.dart';

Future<void> main() async {
  await Global.init();
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();
  final initAd = MobileAds.instance.initialize();
  final admobServices = AdmobServices(initAd);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen(showFlutterNotification);
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
    navigatorKey.currentState!.pushNamed('/suscription');
  });

  runApp(
    MultiProvider(
      providers: [
        ...AppProvider.AllProviders,
        Provider.value(value: admobServices)
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

final navigatorKey = GlobalKey<NavigatorState>();

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return ScreenUtilInit(
      child: MaterialApp(
        navigatorKey: navigatorKey,
        theme: Provider.of<ThemeProvider>(context).themeData,
        debugShowCheckedModeBanner: false,
        initialRoute: '/splash',
        routes: routes,
      ),
    );
  }
}

void showFlutterNotification(RemoteMessage message) {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.high,
      priority: Priority.high,
    ),
  );
  flutterLocalNotificationsPlugin.show(
    0,
    message.notification?.title,
    message.notification?.body,
    notificationDetails,
  );
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Recibido en segundo plano');

  // Verifica si el mensaje contiene datos
  if (message.data.isNotEmpty) {
    // Maneja el mensaje de datos aquí, si es necesario
    print('Data: ${message.data}');

    // Mostrar la notificación usando flutter_local_notifications_plugin
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    // Asegúrate de que el título y el cuerpo no sean null
    flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? 'Título por defecto',
      message.notification?.body ?? 'Cuerpo por defecto',
      notificationDetails,
    );
  }
}

void dialogi() {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (context) {
      return AlertDialog(
        actions: [ElevatedButton(onPressed: () {}, child: const Text('asdas'))],
      );
    },
  );
}

/*
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:templates_flutter_app/common/bloc_providers.dart';
import 'package:templates_flutter_app/common/routes/name.dart';
import 'package:templates_flutter_app/common/services/admob_services.dart';
import 'package:templates_flutter_app/common/services/intialize_app.dart';
import 'package:templates_flutter_app/global.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/notification_bloc.dart';
import 'package:templates_flutter_app/themes/theme_provider.dart';

Future<void> main() async {
  await Global.init();
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();
  final initAd = MobileAds.instance.initialize();
  final admobServices = AdmobServices(initAd);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  

  runApp(
    MultiProvider(
      providers: [
        ...AppProvider.AllProviders,
        Provider.value(value: admobServices)
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

final navigatorKey = GlobalKey<NavigatorState>();
void dialogi() {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (context) {
      return AlertDialog(
        actions: [ElevatedButton(onPressed: () {}, child: const Text('asdas'))],
      );
    },
  );
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return ScreenUtilInit(
      child: MaterialApp(
        navigatorKey: navigatorKey,
        theme: Provider.of<ThemeProvider>(context).themeData,
        debugShowCheckedModeBanner: false,
        initialRoute: '/splash',
        routes: routes,
      ),
    );
  }
}

 */
