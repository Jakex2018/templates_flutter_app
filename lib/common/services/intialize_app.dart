import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:templates_flutter_app/notificacion_messages.dart';
import 'package:templates_flutter_app/screens/suscription/model/suscription_model.dart';
import 'package:templates_flutter_app/screens/suscription/model/user_model.dart';
import 'package:background_fetch/background_fetch.dart';

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
    BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 15,
        stopOnTerminate: false,
        enableHeadless: true,
      ),
      backgroundFetchHeadlessTask,
    )
  ]);
}

Future<void> backgroundFetchHeadlessTask() async {
  print('[BackgroundFetch] Headless task started');
  final userId = await AuthUserProvider().getUserIdFromPreferences();
  if (userId != null) {
    await SuscriptionProvider().checkAndExpireSubscription(userId);
  }
}
