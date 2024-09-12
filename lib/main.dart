import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/common/bloc_providers.dart';
import 'package:templates_flutter_app/common/routes/name.dart';
import 'package:templates_flutter_app/global.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';
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
      //print('Error al verificar la conectividad: $e');
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
      providers: [...AppProvider.AllProviders],
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
        initialRoute: '/splash',
        routes: routes,
      ),
    );
  }
}
