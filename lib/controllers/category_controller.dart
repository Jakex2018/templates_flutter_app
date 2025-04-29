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
