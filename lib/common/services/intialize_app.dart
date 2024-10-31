import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:templates_flutter_app/common/back_services.dart';

Future<void> initializeApp() async {
  await Future.wait([
    initializeService(),
    Permission.notification.isDenied.then((value) {
      if (value) {
        Permission.notification.request();
      }
    }),
    Connectivity().checkConnectivity()
  ]);
}
