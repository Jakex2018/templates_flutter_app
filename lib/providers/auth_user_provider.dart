import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:templates_flutter_app/models/user_model.dart';

class AuthUserProvider with ChangeNotifier {
  bool _isLogged = false;
  bool get isLogged => _isLogged;
  String? _userId;
  String? get userId => _userId;

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isLogged = prefs.getBool('isLoggedIn') ?? false;

    if (_isLogged) {
      final user = FirebaseAuth.instance.currentUser;
      _userId = user?.uid;
      if (_userId != null) {
        await prefs.setString('userId', _userId!);
      }
    } else {
      _userId = null;
    }
    notifyListeners();
  }

  Future<void> setLoggedIn(bool loggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    _isLogged = loggedIn;
    await prefs.setBool('isLoggedIn', loggedIn);

    if (_isLogged) {
      final user = FirebaseAuth.instance.currentUser;
      _userId = user?.uid;
      if (_userId != null) {
        await prefs.setString('userId', _userId!);
      }
    } else {
      _userId = null;
    }
    notifyListeners();
  }

  String getUserId() {
    final user = FirebaseAuth.instance.currentUser;
    return user!.uid;
  }

  Future<String?> getUserIdFromPreferences() {
    final prefs = SharedPreferences.getInstance();
    return prefs.then((prefs) => prefs.getString('userId'));
  }

  Future<UserModel> getUserData() async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(_userId).get();

    if (userDoc.exists) {
      final userData = userDoc.data() as Map<String, dynamic>;
      return UserModel.fromJson(userData);
    } else {
      throw Exception('User not found');
    }
  }
}
