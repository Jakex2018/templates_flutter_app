import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> fetchCategoryType(String categoryName) async {
  // Consulta a Firebase para obtener el tipo de categoría
  final docSnapshot = await FirebaseFirestore.instance
      .collection('categories')
      .where('type', isEqualTo: categoryName)
      .get();

  if (docSnapshot.docs.isNotEmpty) {
    return docSnapshot.docs.first['type'] as String;
  } else {
    // Manejar el caso en que no se encuentre la categoría
    return 'Unknown';
  }
}
