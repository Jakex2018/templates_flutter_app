import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  await admobServices.initialize(); 
  Stripe.publishableKey =
      'pk_test_51QzRAkQjQlDsnuwCZTNwI0CVE61AdUrKWyvAKpa88NrmS6RA4hHetEBpqlwherdoszVyVNM8jgLILgNKCQ1oHiWb00rKaNmbqQ';
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


/*
pub-5699804099110465~1293005254
/*
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Home(),
    );
  }
}
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Builder(
          // Usamos Builder para obtener un contexto que esté dentro del Scaffold
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                // Abre el Sidebar usando el contexto correcto
                Scaffold.of(context).openDrawer();
              },
              child: Text('Abrir Sidebar'),
            );
          },
        ),
      ),
      drawer: Sidebar(), // Agrega el Sidebar
    );
  }
}

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menú',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: Text('Cambiar Tema'),
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toogleTheme();
              },
            ),
          ),
          ListTile(
            title: Text('Opción 1'),
            onTap: () {
              // Acción para la opción 1
            },
          ),
          ListTile(
            title: Text('Opción 2'),
            onTap: () {
              // Acción para la opción 2
            },
          ),
        ],
      ),
    );
  }
}

 */
 */