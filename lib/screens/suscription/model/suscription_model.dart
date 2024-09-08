import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SuscriptionModel {
  final String title;
  final Icon icon;
  final SuscriptionCat? cat;
  final Map<String, String> desc;
  final Map<String, String> items;

  SuscriptionModel({
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
  bool _isSuscribed = false;
  DateTime? _suscriptionEnd;
  final String _subscriptionKey = 'isSubscribed';
  bool get isSuscribed => _isSuscribed;
  DateTime? get suscriptionEndDate => _suscriptionEnd;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Future<void> loadSubscriptionState(String userId) async {
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

  void setSuscription(bool isSuscribed, DateTime? suscriptionEndDate) async {
    _isSuscribed = isSuscribed;
    _suscriptionEnd = suscriptionEndDate;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_subscriptionKey, _isSuscribed);
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
        'subscriptionExpiration': FieldValue.delete(),
      });
    } catch (e) {
      print('asdas');
    }
  }
}
