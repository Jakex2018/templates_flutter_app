import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:templates_flutter_app/common/routes/name.dart';
import 'package:templates_flutter_app/common/services/intialize_app.dart';
import 'package:templates_flutter_app/global.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/providers/theme_provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:templates_flutter_app/providers/app_provider.dart';
import 'package:templates_flutter_app/services/ad_services.dart';

Future<void> main() async {
  await Global.init();
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();
  final admobServices = AdService();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    throw Exception('Error loading .env file: $e');
  }
  await admobServices.initialize();
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLIC_KEY'] ?? '';
  runApp(
    MultiProvider(
      providers: [
        ...AppProvider.allProviders,
        Provider.value(value: admobServices),
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
    return MaterialApp(
      theme: Provider.of<ThemeProvider>(context).themeData,
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: routes,
    );
  }
}
