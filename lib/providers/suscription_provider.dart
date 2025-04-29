import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:templates_flutter_app/notificacion_messages.dart';
import 'package:templates_flutter_app/models/user_model.dart';

class SuscriptionProvider extends ChangeNotifier {
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
    String userId,
  ) async {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 3), (Timer t) async {
      await checkAndExpireSubscription(userId);

      if (!_isSuscribed) {
        _timer?.cancel();
      }
    });
  }

  Future<String?> getFCMTokenFromFirestore(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>;
        return userData['fcm_token'];
      }
      return null;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> checkAndExpireSubscription(String userId) async {
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

              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool(_subscriptionKey, _isSuscribed);
              if (!_isSuscribed) {
                final token = await getFCMTokenFromFirestore(userId);
                if (token != null) {
                  await NotificacionMessages.sendNotification(token);
                } else {
                  throw Exception('No se ha obtenido el token de FCM');
                }
              }
            }
          }
        }
      }
      notifyListeners();
    } catch (e) {
      throw Exception('Error al verificar la expiración de la suscripción: $e');
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

      _suscriptionEnd = subscriptionExpirated;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_subscriptionKey, _isSuscribed);
      notifyListeners();
    } catch (error) {
      //print('Error al actualizar la suscripción:');
    }
  }

  void stopSubscriptionTimer() {
    _timer?.cancel();
  }
}
