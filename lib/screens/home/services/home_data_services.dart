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


 