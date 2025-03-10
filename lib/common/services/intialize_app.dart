import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:templates_flutter_app/notificacion_messages.dart';



@pragma('vm:entry-point')
Future<void> initializeApp() async {
  await Future.wait([
    NotificacionMessages.initializeMessagin(),
    
    Permission.notification.isDenied.then((value) {
      if (value) {
        Permission.notification.request();
      }
    }),
    Connectivity().checkConnectivity(),
    
  ]);
}