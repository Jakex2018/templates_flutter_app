import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/global.dart';
import 'package:templates_flutter_app/screens/home/home_app.dart';
import 'package:templates_flutter_app/screens/login/login_screen.dart';
import 'package:templates_flutter_app/screens/register/register_screen.dart';
import 'package:templates_flutter_app/screens/suscription/suscription_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/themes/dark_mode.dart';
import 'package:templates_flutter_app/themes/theme_provider.dart';

class ConnectivityModel extends ChangeNotifier {
  ConnectivityResult _connectivityResult = ConnectivityResult.none;

  ConnectivityResult get connectivityResult => _connectivityResult;

  Future<void> initConnectivity() async {
    try {
      final result = await Connectivity().checkConnectivity();
      _connectivityResult = result;
      notifyListeners();
    } catch (e) {
      print('Error al verificar la conectividad: $e');
    }
  }

  void onConnectivityChanged(ConnectivityResult result) {
    _connectivityResult = result;
    notifyListeners();
  }
}

Future<void> main() async {
  await Global.init();
  WidgetsFlutterBinding.ensureInitialized();
  Connectivity().checkConnectivity();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ConnectivityModel()..initConnectivity(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
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
    return ScreenUtilInit(
      child: MaterialApp(
      
        theme: Provider.of<ThemeProvider>(context).themeData,
        debugShowCheckedModeBanner: false,
        initialRoute: '/home',
        routes: routes,
      ),
    );
  }
}

final routes = <String, WidgetBuilder>{
  '/login': (context) => const Login(),
  '/home': (context) => const Home(),
  '/register': (context) => const RegisterScreen(),
  '/suscription': (context) => const SuscriptionScreen()
};


/*
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/global.dart';
import 'package:templates_flutter_app/screens/home/home_app.dart';
import 'package:templates_flutter_app/screens/login/login_screen.dart';
import 'package:templates_flutter_app/screens/register/register_screen.dart';
import 'package:templates_flutter_app/screens/suscription/suscription_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';

class ConnectivityModel extends ChangeNotifier {
  ConnectivityResult _connectivityResult = ConnectivityResult.none;

  ConnectivityResult get connectivityResult => _connectivityResult;

  Future<void> initConnectivity() async {
    try {
      final result = await Connectivity().checkConnectivity();
      _connectivityResult = result;
      notifyListeners();
    } catch (e) {
      print('Error al verificar la conectividad: $e');
    }
  }

  void onConnectivityChanged(ConnectivityResult result) {
    _connectivityResult = result;
    notifyListeners();
  }
}

Future<void> main() async {
  await Global.init();
  WidgetsFlutterBinding.ensureInitialized();
  Connectivity().checkConnectivity();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ConnectivityModel()..initConnectivity(),
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
    return ScreenUtilInit(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/home',
        routes: routes,
      ),
    );
  }
}

final routes = <String, WidgetBuilder>{
  '/login': (context) => const Login(),
  '/home': (context) => const Home(),
  '/register': (context) => const RegisterScreen(),
  '/suscription': (context) => const SuscriptionScreen()
};

 */