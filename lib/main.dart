import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:templates_flutter_app/common/routes/name.dart';
import 'package:templates_flutter_app/common/services/admob_services.dart';
import 'package:templates_flutter_app/common/services/intialize_app.dart';
import 'package:templates_flutter_app/global.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/providers/theme_provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:templates_flutter_app/providers/app_provider.dart';

Future<void> main() async {
  await Global.init();
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();
  final initAd = MobileAds.instance.initialize();
  final admobServices = AdmobServices(initAd);
  Stripe.publishableKey =
      'pk_test_51QzRAkQjQlDsnuwCZTNwI0CVE61AdUrKWyvAKpa88NrmS6RA4hHetEBpqlwherdoszVyVNM8jgLILgNKCQ1oHiWb00rKaNmbqQ';
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
