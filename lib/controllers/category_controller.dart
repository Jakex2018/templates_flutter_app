import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:templates_flutter_app/services/connectivity_services.dart';
import 'package:templates_flutter_app/services/template_data_services.dart';

import 'package:flutter/material.dart'; // Asegúrate de importar el paquete necesario

abstract class CategoryController extends ChangeNotifier {
  Stream<QuerySnapshot<Map<String, dynamic>>> getTemplatesByCategory(
      String category);
  Stream<ConnectivityResult> get connectivityStream;
  void changePage(int index);

  int get itemsPerPage;
  int get currentPage;
  set currentPage(int value);
}

class CategoryControllerImpl implements CategoryController {
  final TemplateDataService templateService;
  final ConnectivityService connectivityService;

  CategoryControllerImpl({
    required this.templateService,
    required this.connectivityService,
  });

  @override
  int currentPage = 0;

  @override
  int itemsPerPage = 2;

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getTemplatesByCategory(
      String category) {
    return templateService.getTemplatesByCategory(category);
  }

  @override
  Stream<ConnectivityResult> get connectivityStream {
    return connectivityService.connectivityStream;
  }

  @override
  void changePage(int index) {
    currentPage = index;
    notifyListeners(); // Asegúrate de notificar a los oyentes cuando cambie la página.
  }

  @override
  void addListener(VoidCallback listener) {
    // TODO: implement addListener
    
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  // TODO: implement hasListeners
  bool get hasListeners => throw UnimplementedError();

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
  }

  @override
  void removeListener(VoidCallback listener) {
    // TODO: implement removeListener
  }
}
