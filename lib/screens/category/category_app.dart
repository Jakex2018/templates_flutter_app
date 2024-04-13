import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/screens/category/widget/category_card.dart';
import 'package:templates_flutter_app/screens/category/widget/category_type_content.dart';
import 'package:templates_flutter_app/screens/home/widget/home_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:number_paginator/number_paginator.dart';

class Category extends StatefulWidget {
  const Category({super.key});

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
    const int itemsPerPage = 10;
    return Material(
      child: Stack(children: [
        HomeBackground(
          onPressed: () => Navigator.of(context).pop(),
          sidebarIcon: Icons.arrow_back_ios_new_outlined,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const CategoryTypeContent(),
            showTemplates(currentPage, itemsPerPage, showProgress),
          ],
        ),
      ]),
    );
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> showTemplates(
      int currentPage, int itemsPerPage, bool showProgress) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('templates').snapshots(),
      builder: (context, snapshot) {
        if (showProgress) {
          return Container(
              height: 550.h,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: const Center(child: CircularProgressIndicator()));
        }
        final documents = snapshot.data!.docs;
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
                    numberPages: documents.length ~/ itemsPerPage +
                        (documents.length % itemsPerPage > 0
                            ? 1
                            : 0), // Calcular páginas totales
                    onPageChange: (page) => currentPage = page,
                  ),
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