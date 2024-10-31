import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:templates_flutter_app/common/back_services.dart';
import 'package:templates_flutter_app/screens/suscription/model/user_model.dart';
import 'package:templates_flutter_app/screens/suscription/suscription_screen.dart';

class SuscriptionModel {
  final String title;
  final Icon icon;
  final SuscriptionCat? cat;
  final Map<String, String> desc;
  final Map<String, String> items;
  final double? price;

  SuscriptionModel({
    this.price,
    required this.cat,
    required this.desc,
    required this.items,
    required this.title,
    required this.icon,
  });
}

final List<SuscriptionModel> infoCard = [
  SuscriptionModel(
    title: 'Free',
    icon: const Icon(Icons.coffee, size: 100, color: Colors.white),
    desc: {
      'desc01': 'Templates Free',
      'desc02': 'Limitated Chat Bot',
      'desc03': '5 Coins for day IA Chat Bot'
    },
    items: {
      'items01': 'asset/verify.png',
      'items02': 'asset/verify.png',
      'items03': 'asset/verify.png',
    },
    cat: SuscriptionCat.free,
  ),
  SuscriptionModel(
      price: 4.99,
      title: 'Premium',
      desc: {
        'desc01': 'Templates Premium',
        'desc02': 'Ilimitated Chat Bot',
        'desc03': 'Ilimitates coins IA Chat Bot'
      },
      items: {
        'items01': 'asset/verify.png',
        'items02': 'asset/verify.png',
        'items03': 'asset/verify.png',
      },
      icon: const Icon(
        Icons.rocket,
        size: 100,
        color: Colors.white,
      ),
      cat: SuscriptionCat.premium),
];

enum SuscriptionCat { free, premium }

class SuscriptionProvider with ChangeNotifier {
  //ID USER FOR EXPIRATED SUSCRIPTION
  UserModel? _user;
  UserModel? get user => _user;

  bool _isSuscribed = false;
  DateTime? _suscriptionEnd;
  final String _subscriptionKey = 'isSubscribed';
  bool get isSuscribed => _isSuscribed;
  DateTime? get suscriptionEndDate => _suscriptionEnd;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Timer? _timer;

  Future<void> loadSubscriptionState(String? userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isSubscribedFromPrefs = prefs.getBool(_subscriptionKey);

    if (isSubscribedFromPrefs == null) {
      try {
        DocumentSnapshot userDoc =
            await _firebaseFirestore.collection('users').doc(userId).get();
        bool subscriptionStatus = userDoc.get('isSubscribed') ?? false;
        userDoc.exists
            ? _isSuscribed = subscriptionStatus
            : _isSuscribed = false;
        // ignore: empty_catches
      } catch (e) {
        _isSuscribed = false;
      }
    } else {
      _isSuscribed = isSubscribedFromPrefs;
    }

    notifyListeners();
  }

  void cancelSuscription(String userId, DateTime? suscriptionEndDate) async {
    _isSuscribed = false;

    suscriptionEndDate = null;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_subscriptionKey, _isSuscribed);

    try {
      await _firebaseFirestore.collection('users').doc(userId).update({
        'isSubscribed': _isSuscribed,
        'subscriptionDate': FieldValue.delete(),
        'subscriptionExpirated': FieldValue.delete(),
      });
    } catch (e) {
      return;
    }
  }

  Future<void> expireSubscription(String userId) async {
    try {
      // Ajusta el intervalo según tus necesidades
      await _firebaseFirestore.collection('users').doc(userId).update({
        'isSubscribed': false,
        'subscriptionDate': FieldValue.delete(),
        'subscriptionExpirated': FieldValue.delete(),
      });
      //print('Suscription Expirada correctamente');
      notifyListeners();
    } catch (e) {
      // Manejar errores
      //print('Error al expirar la suscripción: $e');
    }
  }

  Future<void> startSubscriptionGlobal(
      String userId, BuildContext context) async {
    _timer?.cancel();

    // Create a new timer that checks the subscription status periodically
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer t) async {
      await checkAndExpireSubscription(userId, context);

      // Stop the timer if the subscription is expired
      if (!_isSuscribed) {
        _timer?.cancel();
      }
    });
  }

  Future<void> checkAndExpireSubscription(
      String userId, BuildContext context) async {
    try {
      final snapshot =
          await _firebaseFirestore.collection('users').doc(userId).get();
      if (snapshot.exists) {
        final userData = snapshot.data();
        if (userData != null) {
          final subscriptionExpiratedTimestamp =
              userData['subscriptionExpirated'];
          if (subscriptionExpiratedTimestamp is Timestamp) {
            final subscriptionExpirated =
                subscriptionExpiratedTimestamp.toDate();
            final now = DateTime.now();
            if (now.isAfter(subscriptionExpirated)) {
              _isSuscribed = false;
              await _firebaseFirestore.collection('users').doc(userId).update({
                'isSubscribed': _isSuscribed,
                'subscriptionDate': FieldValue.delete(),
                'subscriptionExpirated': FieldValue.delete(),
              });

              //print(_isSuscribed);

              // Verifica si la actualización ha tenido efecto
              final updatedSnapshot = await _firebaseFirestore
                  .collection('users')
                  .doc(userId)
                  .get();
              final updatedData = updatedSnapshot.data();
              final updatedIsSubscribed = updatedData?['isSubscribed'] ?? false;
              //print('Updated isSubscribed: $updatedIsSubscribed');
              notifyListeners();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool(_subscriptionKey, _isSuscribed);
              if (!updatedIsSubscribed) {
                //print('Successfully updated subscription status.');
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 3),
                    margin: EdgeInsets.only(bottom: 50, left: 60, right: 50),
                    content: Text('Subscription expired successfully.'),
                  ),
                );
              }
              const InitializationSettings initializationSettings =
                  InitializationSettings(
                android: AndroidInitializationSettings('@mipmap/ic_launcher'),
              );
              // ignore: use_build_context_synchronously
              flutterLocalNotificationsPlugin.initialize(
                initializationSettings,
                onDidReceiveNotificationResponse:
                    (NotificationResponse response) {
                  final payload = response.payload;
                  if (payload != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SuscriptionScreen(),
                      ),
                    );

                    flutterLocalNotificationsPlugin.cancel(13123);
                  }
                },
              );
              // ignore: use_build_context_synchronously
              showrNotificacions(context);
            } else {
              //('Subscription is still valid.');
            }
          } else {
            //print('Invalid or missing timestamp fields.');
          }
        }
      }
    } catch (e) {
      //print('Error al verificar la expiración de la suscripción: $e');
    }
  }

  Future<void> activateSubscription(String userId, bool isSubscribed,
      DateTime subscriptionDate, DateTime subscriptionExpirated) async {
    final db = FirebaseFirestore.instance;

    try {
      await db.collection('users').doc(userId).update({
        'isSubscribed': isSubscribed,
        'subscriptionDate': subscriptionDate,
        'subscriptionExpirated': subscriptionExpirated
      });
      _isSuscribed = isSubscribed;

      ///print(_isSuscribed);
      _suscriptionEnd = subscriptionExpirated;

      notifyListeners();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(
          _subscriptionKey, _isSuscribed); // Notify listeners when data changes
      ///print('PAGASTE UNA SUSCRIPCION');
    } catch (error) {
      //print('Error al actualizar la suscripción:');
    }
  }

  void stopSubscriptionTimer() {
    _timer?.cancel();
  }
}

/*
const InitializationSettings initializationSettings =
                  InitializationSettings(
                android: AndroidInitializationSettings('@mipmap/ic_launcher'),
              );
 */
/*
 flutterLocalNotificationsPlugin.initialize(
                initializationSettings,
                onDidReceiveNotificationResponse:
                    (NotificationResponse response) {
                  final payload = response.payload;
                  if (payload != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SuscriptionScreen(),
                      ),
                    );

                    flutterLocalNotificationsPlugin.cancel(13123);
                  }
                },
              );
 */