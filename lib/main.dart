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
import 'package:templates_flutter_app/themes/theme_provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> main() async {
  await Global.init();
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();
  final initAd = MobileAds.instance.initialize();
  final admobServices = AdmobServices(initAd);
  Stripe.publishableKey = 'pk_test_51QzRAkQjQlDsnuwCZTNwI0CVE61AdUrKWyvAKpa88NrmS6RA4hHetEBpqlwherdoszVyVNM8jgLILgNKCQ1oHiWb00rKaNmbqQ';
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

/*
ndkVersion = flutter.ndkVersion
 */

/*
'1.7.10'  image_gallery_saver: ^2.0.3
flutter_local_notifications: ^18.0.1
flutter_background_service: ^5.0.0
  permission_handler: ^11.1.0
  flutter_background_service_android: ^6.2.7
  firebase_messaging: ^15.1.1
  google_mobile_ads: ^5.1.0
  intl: ^0.20.2
  flutter_credit_card: ^4.0.1
  flutter_paypal: ^0.2.1
  googleapis: ^13.2.0
  googleapis_auth: ^1.6.0
  firebase_auth: ^5.2.1
  firebase_core: ^3.4.1
  cloud_firestore: ^5.4.1
  flutter_cache_manager: ^3.3.1
  url_launcher: ^6.2.5
  path_provider: ^2.1.2
  http: ^1.2.1
  fluttertoast: ^8.2.4
  number_paginator: ^0.4.1
  webview_flutter: ^4.9.0
  webview_flutter_android: ^3.16.9
  cached_network_image: ^3.3.1
  shared_preferences: ^2.2.3
  google_sign_in: ^6.2.1
  gif_view: ^1.0.0
  connectivity_plus: ^6.0.5
  provider: ^6.1.2
  file_picker: ^8.0.7
 */

/*
sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17

        saver_gallery:
  flutter_stripe:
 */
