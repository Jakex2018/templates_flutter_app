import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:templates_flutter_app/widget/card_label.dart';

class HomeDataService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> getUsername() async {
    final user = _auth.currentUser;
    return user?.displayName;
  }



  StreamBuilder<QuerySnapshot<Object?>> typeCat(Map<String, String> category) {
    return StreamBuilder<QuerySnapshot<Object?>>(
        stream: FirebaseFirestore.instance
            .collection('categories')
            .where('category', isEqualTo: category['category'])
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          final data = snapshot.data!.docs.first;
          final type = data['type'];
          return CardLabel(type: type);
        });
  }

  Future<List<Map<String, String>>> getCategory() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    final categories = querySnapshot.docs.map((doc) {
      final categoryData = doc.data();
      return {
        'category': categoryData['category'] as String,
        'imageCategory': categoryData['imageCategory'] as String,
      };
    }).toList();
    return categories;
  }
}


/*
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeDataService {
  Future<List<Map<String, String>>> getCategory() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    final categories = querySnapshot.docs.map((doc) {
      final categoryData = doc.data();
      return {
        'category': categoryData['category'] as String,
        'imageCategory': categoryData['imageCategory'] as String,
      };
    }).toList();
    return categories;
  }
}
 */