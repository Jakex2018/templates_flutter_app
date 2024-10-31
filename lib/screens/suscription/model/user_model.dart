import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  String? email;
  String? username;
  bool? isSubscribed;

  UserModel({this.email = '', this.username = "", this.isSubscribed = false});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      username: map['username'] ?? '',
      isSubscribed: map['isSubscribed'] ?? false,
    );
  }
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] as String,
      username: json['username'] as String,
      isSubscribed: json['isSubscribed'] as bool,
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

  String getUserId() {
    final user = FirebaseAuth.instance.currentUser;
    return user!.uid;
  }

  Future<UserModel> getUserData() async {
    // Reemplaza 'users' con el nombre real de tu colección de usuarios
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
