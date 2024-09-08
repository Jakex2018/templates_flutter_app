import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  String? email;
  String? username;
  bool isSubscribed;

  UserModel({this.email = '', this.username = "", this.isSubscribed = false});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      username: map['username'] ?? '',
      isSubscribed: map['isSubscribed'] ?? false,
    );
  }
  Map<String, dynamic> toMap() {
    return {'email': email, 'username': username, 'isSubscribed': isSubscribed};
  }
}

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
    } else {
      _userId = null;
    }
    notifyListeners();
  }

  String? getUserId() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }
}
