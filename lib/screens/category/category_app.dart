import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/screens/category/widget/category_card.dart';
import 'package:templates_flutter_app/screens/category/widget/category_type_content.dart';
import 'package:templates_flutter_app/screens/home/widget/home_background.dart';
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
                    return CategoryCard(image: imageUrl);
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



/*
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/screens/category/widget/category_card.dart';
import 'package:templates_flutter_app/screens/category/widget/category_type_content.dart';
import 'package:templates_flutter_app/screens/home/widget/home_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class Category extends StatefulWidget {
  const Category({super.key, required this.category});
  final String category;
  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  int currentPage = 0;
  int itemsPerPage = 2;
  int loadedDocs = 0;

  bool showProgress = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        showProgress = false;
      });
    });
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
            showTemplates(currentPage, itemsPerPage, loadedDocs, showProgress,
                widget.category),
          ],
        ),
      ]),
    );
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> showTemplates(
    int currentPage,
    int itemsPerPage,
    int loadedDocs,
    bool showProgress,
    String category,
  ) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('templates')
          .where('category', isEqualTo: category)
          .snapshots(),
      builder: (context, snapshot) {
        if (showProgress) {
          return Container(
              height: 550.h,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: const Center(child: CircularProgressIndicator()));
        }

        final documents = snapshot.data!.docs;
        int itemsPerPage = min(documents.length, 2);

        final int totalPages = (documents.length / itemsPerPage).ceil();
        currentPage = min(currentPage, totalPages - 1);
        currentPage = currentPage.clamp(0, totalPages - 1);
        final int startIndex = max(0, loadedDocs - currentPage * itemsPerPage);
        final filteredDocs = documents.sublist(
            startIndex, min((startIndex + itemsPerPage), documents.length));

        return Container(
          height: 550.h,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, index) => FutureBuilder(
                          future:
                              _buildCategoryCard(context, index, filteredDocs),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            }
                            return snapshot.data!;
                          },
                        ),
                    childCount: totalPages),
              ),
              SliverPadding(
                padding: EdgeInsets.only(top: 7.0.h),
                sliver: SliverToBoxAdapter(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: currentPage > 0
                            ? () {
                                currentPage > 0;
                              }
                            : null,
                        child: const Text('Previous')),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text('${currentPage + 1}/$totalPages'),
                    SizedBox(
                      width: 10.w,
                    ),
                    TextButton(
                      onPressed: currentPage < totalPages
                          ? () => setState(() {
                                currentPage++;
                                loadedDocs += filteredDocs.length;
                              })
                          : null,
                      child: const Text('Siguiente'),
                    ),
                  ],
                )),
              ),
            ],
          ),
        );
      },
    );
  }
}

Future<CategoryCard> _buildCategoryCard(BuildContext context, int index,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> filteredDocs) async {
  final doc = filteredDocs[index];
  final imageUrl = doc['image'];
  return CategoryCard(image: imageUrl);
}
 */

/*
(currentPage - 1) * itemsPerPage,
            currentPage * itemsPerPage <= documents.length
                ? currentPage * itemsPerPage
                : documents.length
 
*/

/*
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/screens/category/widget/category_card.dart';
import 'package:templates_flutter_app/screens/category/widget/category_type_content.dart';
import 'package:templates_flutter_app/screens/home/widget/home_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:number_paginator/number_paginator.dart';

class Category extends StatefulWidget {
  const Category({super.key, required this.category});
  final String category;
  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  bool showProgress = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        showProgress = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    int currentPage = 1;
    const int itemsPerPage = 2;
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
            showTemplates(
                currentPage, itemsPerPage, showProgress, widget.category),
          ],
        ),
      ]),
    );
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> showTemplates(
    int currentPage,
    int itemsPerPage,
    bool showProgress,
    String category,
  ) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('templates')
          .where('category', isEqualTo: category)
          .snapshots(),
      builder: (context, snapshot) {
        if (showProgress) {
          return Container(
              height: 550.h,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: const Center(child: CircularProgressIndicator()));
        }

        final documents = snapshot.data!.docs;
        final int totalPages = documents.length ~/ itemsPerPage +
            (documents.length % itemsPerPage > 0 ? 1 : 0);
        currentPage = min(currentPage, totalPages - 1);
        final filteredDocs = documents.sublist(
            (currentPage - 1) * itemsPerPage,
            currentPage * itemsPerPage <= documents.length
                ? currentPage * itemsPerPage
                : documents.length);
        return Container(
          height: 550.h,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: CustomScrollView(
            slivers: [
              SliverGrid(
                delegate: SliverChildBuilderDelegate(
                    (context, index) => FutureBuilder(
                          future:
                              _buildCategoryCard(context, index, filteredDocs),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            }
                            return snapshot.data!;
                          },
                        ),
                    childCount: filteredDocs.length),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 1.0,
                  mainAxisExtent: 300.00,
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.only(top: 7.0.h),
                sliver: SliverToBoxAdapter(
                  child: NumberPaginator(
                      numberPages: totalPages, // Calcular páginas totales
                      onPageChange: (page) => setState(() {
                            currentPage = page;
                          })),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Future<CategoryCard> _buildCategoryCard(BuildContext context, int index,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> filteredDocs) async {
  final doc = filteredDocs[index];
  final imageUrl = doc['image'];
  return CategoryCard(image: imageUrl);
}
 */