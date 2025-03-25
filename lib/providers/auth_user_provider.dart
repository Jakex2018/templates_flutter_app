import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthUserProvider with ChangeNotifier {
  bool _isLogged = false;
  bool get isLogged => _isLogged;

  String? _userId;
  String? get userId => _userId;

  // ignore: prefer_final_fields
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _username;
  String? get username => _username;
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isLogged = prefs.getBool('isLoggedIn') ?? false;

    if (_isLogged) {
      final user = FirebaseAuth.instance.currentUser;
      _userId = user?.uid;
      if (_userId != null) {
        await prefs.setString('userId', _userId!);
        _username = await getUsername(); // Cargar el username
      }
    } else {
      _userId = null;
      _username = null; // Limpiar el username si no hay sesión
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
        _username = await getUsername(); // Cargar el username
      }
    } else {
      _userId = null;
      _username = null; // Limpiar el username si el usuario cierra sesión
    }
    notifyListeners();
  }

  String getUserId() {
    final user = FirebaseAuth.instance.currentUser;
    return user!.uid;
  }

  Future<String?> getUserIdFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<String?> getUsername() async {
    if (_userId == null) {
      return null; // Si no hay userId, no hay username
    }

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        return userData['username'] as String?; // Obtener el username
      } else {
        return null; // Si no existe el documento, retornar null
      }
    } catch (e) {
      return null; // Si hay un error, retornar null
    }
  }
}
