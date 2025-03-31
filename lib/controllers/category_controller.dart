import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:templates_flutter_app/services/connectivity_services.dart';
import 'package:templates_flutter_app/services/template_data_services.dart';
import 'package:flutter/material.dart'; 

class CategoryController extends ChangeNotifier {
  final TemplateDataService templateService;
  final ConnectivityService connectivityService;

  CategoryController({
    required this.templateService,
    required this.connectivityService,
  });

  int currentPage = 0;
  final int itemsPerPage = 2;

  late Stream<QuerySnapshot<Map<String, dynamic>>> templatesStream;
  late Stream<ConnectivityResult> connectivityStream;

  late Stream<Map<String, dynamic>> combinedStream;

  void initializeStreams(String category) {
    templatesStream = templateService.getTemplatesByCategory(category);
    connectivityStream = connectivityService.connectivityStream;

    combinedStream = _combineStreams(templatesStream, connectivityStream);
  }

  Stream<Map<String, dynamic>> _combineStreams(
    Stream<QuerySnapshot<Map<String, dynamic>>> templatesStream,
    Stream<ConnectivityResult> connectivityStream,
  ) {
    return Stream<Map<String, dynamic>>.multi((controller) {
      StreamSubscription? connectivitySubscription;
      StreamSubscription? templatesSubscription;

      connectivitySubscription = connectivityStream.listen((connectivity) {
        controller.add({'connectivity': connectivity});
      });

      templatesSubscription = templatesStream.listen((templates) {
        controller.add({'templates': templates});
      });

      controller.onCancel = () {
        connectivitySubscription?.cancel();
        templatesSubscription?.cancel();
      };
    });
  }

  void changePage(int index) {
    final filteredTemplates = getFilteredTemplates([]);
    final maxPage = (filteredTemplates.isNotEmpty)
        ? (filteredTemplates.length / itemsPerPage).ceil() - 1
        : 0;
    currentPage = index.clamp(0, maxPage);
    notifyListeners();
  }

  List<DocumentSnapshot<Map<String, dynamic>>> getFilteredTemplates(
      List<DocumentSnapshot<Map<String, dynamic>>> documents) {
    final startIndex = currentPage * itemsPerPage;
    return documents.sublist(
      startIndex,
      min(startIndex + itemsPerPage, documents.length),
    );
  }
}



/*
abstract class CategoryController extends ChangeNotifier {
  Stream<QuerySnapshot<Map<String, dynamic>>> getTemplatesByCategory(String category);
  Stream<ConnectivityResult> get connectivityStream;
  void changePage(int index);

  int get itemsPerPage;
  int get currentPage;
  set currentPage(int value);
}

class CategoryControllerImpl extends CategoryController {
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
  Stream<QuerySnapshot<Map<String, dynamic>>> getTemplatesByCategory(String category) {
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
}
 */

/*
abstract class CategoryController extends ChangeNotifier {
  Stream<QuerySnapshot<Map<String, dynamic>>> getTemplatesByCategory(
      String category);
  List<DocumentSnapshot<Map<String, dynamic>>> getFilteredTemplates(
      List<DocumentSnapshot<Map<String, dynamic>>> documents);
  Stream<ConnectivityResult> get connectivityStream;
  Stream<Map<String, dynamic>> combinedStream(String category);

  void changePage(int index);
  set currentPage(int value);

  int get itemsPerPage;
  int get currentPage;

  // Métodos adicionales para controlar la paginación
  void incrementPage();
  void decrementPage();
}

class CategoryControllerImpl extends CategoryController {
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
  Stream<Map<String, dynamic>> combinedStream(String category) {
    return Rx.combineLatest2(
      getTemplatesByCategory(category),
      connectivityStream,
      (QuerySnapshot<Map<String, dynamic>> templates,
          ConnectivityResult connectivity) {
        return {
          'templates': templates,
          'connectivity': connectivity,
        };
      },
    );
  }

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
    // Asegurarse de que la página esté dentro de los límites
    currentPage = index.clamp(
        0, (getFilteredTemplates([]).length / itemsPerPage).ceil() - 1);
    notifyListeners();
  }

  @override
  void incrementPage() {
    changePage(currentPage + 1);
  }

  @override
  void decrementPage() {
    changePage(currentPage - 1);
  }

  @override
  List<DocumentSnapshot<Map<String, dynamic>>> getFilteredTemplates(
      List<DocumentSnapshot<Map<String, dynamic>>> templates) {
    final totalPages = (templates.length / itemsPerPage).ceil();
    currentPage = currentPage.clamp(0, totalPages - 1);

    final startIndex = max(0, currentPage * itemsPerPage);
    return templates.sublist(
      startIndex,
      min(startIndex + itemsPerPage, templates.length),
    );
  }
}
 */