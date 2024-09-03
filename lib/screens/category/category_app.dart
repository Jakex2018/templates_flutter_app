import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/screens/category/widget/category_card.dart';
import 'package:templates_flutter_app/screens/category/widget/category_type_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:number_paginator/number_paginator.dart';

class Category extends StatefulWidget {
  const Category({super.key, required this.category});
  final String category;
  @override
  // ignore: library_private_types_in_public_api
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  bool showProgress = true;
  int currentPage = 0;
  int itemsPerPage = 2;

  // Stream to listen for changes in the templates collection
  Stream<QuerySnapshot<Map<String, dynamic>>>? _templatesStream;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        showProgress = false;
      });
    });
    _templatesStream = FirebaseFirestore.instance
        .collection('templates')
        .where('category', isEqualTo: widget.category)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: showProgress
            ? Center(
                child: Container(
                  margin: EdgeInsets.only(top: 50.h),
                  width: 50,
                  height: 50,
                  child: const CircularProgressIndicator(),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  title: Text(
                    'Category',
                    style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer),
                  ),
                ),
                body: Stack(children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CategoryTypeContent(
                        title: widget.category,
                      ),
                      showTemplates(stream: _templatesStream!),
                    ],
                  ),
                ]),
              ));
  }

  Widget showTemplates(
      {required Stream<QuerySnapshot<Map<String, dynamic>>> stream}) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (showProgress) {
          return Container(
              height: 550.h,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).colorScheme.background,
              child: const Center(child: CircularProgressIndicator()));
        }

        final documents = snapshot.data!.docs;

        final totalPages = (documents.length / itemsPerPage).ceil();

        currentPage = min(currentPage, totalPages - 1);
        currentPage = currentPage.clamp(0, totalPages - 1);

        final startIndex = max(0, currentPage * itemsPerPage);
        final filteredDocs = documents.sublist(
            startIndex, min(startIndex + itemsPerPage, documents.length));

        return SizedBox(
          height: 560.h,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                height: 515.h,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).colorScheme.secondary,
                child: ListView.builder(
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final doc = filteredDocs[index];
                    final imageUrl = doc['image'];
                    return CategoryCard(
                      image: imageUrl,
                    );
                  },
                ),
              ),
              NumberPaginator(
                config: NumberPaginatorUIConfig(
                  buttonSelectedBackgroundColor:
                      Theme.of(context).colorScheme.onTertiary,
                ),
                numberPages: totalPages,
                onPageChange: (index) => setState(() => currentPage = index),
              ),
            ],
          ),
        );
      },
    );
  }
}

/*
final documents = snapshot.data!.docs;

        final totalPages = (documents.length / itemsPerPage).ceil();

        currentPage = min(currentPage, totalPages - 1);
        currentPage = currentPage.clamp(0, totalPages - 1);

        final startIndex = max(0, currentPage * itemsPerPage);
        final filteredDocs = documents.sublist(
            startIndex, min(startIndex + itemsPerPage, documents.length));

 */
/*
class Category extends StatefulWidget {
  const Category({super.key, required this.category});
  final String category;
  @override
  // ignore: library_private_types_in_public_api
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  bool showProgress = true;
  int currentPage = 0;
  int itemsPerPage = 2;

  // Stream to listen for changes in the templates collection
  Stream<QuerySnapshot<Map<String, dynamic>>>? _templatesStream;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        showProgress = false;
      });
    });
    _templatesStream = FirebaseFirestore.instance
        .collection('templates')
        .where('category', isEqualTo: widget.category)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(children: [
        HomeBackground(
          onPressed: () => Navigator.of(context).pop(),
          sidebarIcon: Icons.arrow_back_ios_new_outlined,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CategoryTypeContent(
              title: widget.category,
            ),
            showTemplates(stream: _templatesStream!),
          ],
        ),
      ]),
    );
  }

  Widget showTemplates(
      {required Stream<QuerySnapshot<Map<String, dynamic>>> stream}) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (showProgress) {
          return Container(
              height: 550.h,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: const Center(child: CircularProgressIndicator()));
        }

        final documents = snapshot.data!.docs;

        final totalPages = (documents.length / itemsPerPage).ceil();

        currentPage = min(currentPage, totalPages - 1);
        currentPage = currentPage.clamp(0, totalPages - 1);

        final startIndex = max(0, currentPage * itemsPerPage);
        final filteredDocs = documents.sublist(
            startIndex, min(startIndex + itemsPerPage, documents.length));

        return Container(
          height: 560.h,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                height: 510.h,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: ListView.builder(
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final doc = filteredDocs[index];
                    final imageUrl = doc['image'];
                    return CategoryCard(
                      image: imageUrl,
                    );
                  },
                ),
              ),
              NumberPaginator(
                numberPages: totalPages,
                onPageChange: (index) => setState(() => currentPage = index),
              ),
            ],
          ),
        );
      },
    );
  }
}


 */