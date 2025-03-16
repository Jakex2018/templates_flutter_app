import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/services/fetch_category_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:number_paginator/number_paginator.dart';
import 'package:templates_flutter_app/views/home_app.dart';
import 'package:templates_flutter_app/widget/splash_subscribe.dart';
import 'package:templates_flutter_app/providers/suscription_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:templates_flutter_app/common/constants/constants.dart';
import 'package:templates_flutter_app/widget/error_category_image.dart';
import 'package:templates_flutter_app/views/template_app.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Category extends StatefulWidget {
  const Category({
    super.key,
    required this.category,
    required this.type,
  });
  final String category;
  final String type;
  @override
  // ignore: library_private_types_in_public_api
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  int currentPage = 0;
  int itemsPerPage = 2;
  Stream<QuerySnapshot<Map<String, dynamic>>>? _templatesStream;

  @override
  void initState() {
    super.initState();

    _templatesStream = FirebaseFirestore.instance
        .collection('templates')
        .where('category', isEqualTo: widget.category)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchCategoryType(widget.type), // Obtén el tipo de categoría
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 60,
            width: 60,
            color: Theme.of(context).colorScheme.surface,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // Obtén el valor de categoryType
        final categoryType = snapshot.data!;

        // Pasa categoryType al Consumer
        return Consumer<SuscriptionProvider>(
          builder: (context, subscriptionProvider, child) {
            if (categoryType == 'Free' ||
                subscriptionProvider.isSuscribed == true) {
              return Material(
                child: Scaffold(
                  appBar: AppBar(
                    title: Text(
                      'Category',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  body: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CategoryTypeContent(
                            title: widget.category,
                          ),
                          showTemplates(stream: _templatesStream!),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else if (categoryType == 'Premium') {
              return const SplashSuscribe(
                widgetScreen: Home(),
                titleSuscription: 'Your Subscription has Expired',
              );
            } else {
              return const Material();
            }
          },
        );
      },
    );
  }

  Widget showTemplates({
    required Stream<QuerySnapshot<Map<String, dynamic>>> stream,
  }) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
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

class CategoryCard extends StatefulWidget {
  const CategoryCard({
    super.key,
    required this.image,
  });

  final String image;

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
        stream: Connectivity()
            .onConnectivityChanged
            .map((results) => results.first),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error de conectividad');
          }

          return GestureDetector(
              onTap: () {
                if (snapshot.data != ConnectivityResult.none) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Template(
                        image: widget.image,
                      ),
                    ),
                  );
                } else if (snapshot.data == ConnectivityResult.none) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Error Network'),
                        content: const Text('Please Connet your Internet.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: snapshot.data == ConnectivityResult.none
                  ? const ErrorCategoryImage()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: aDefaultPadding * 2,
                        vertical: aDefaultPadding,
                      ),
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.sp),
                            border: BorderDirectional(
                                top: BorderSide(
                                    color: Colors.black12, width: 2.w)),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10.sp,
                                offset: Offset(0, 10.sp),
                                color: Colors.black26,
                              )
                            ]),
                        child: FutureBuilder(
                          future: precacheImage(
                            NetworkImage(widget.image),
                            context,
                          ),
                          builder: (context, snapshot) {
                            return CachedNetworkImage(
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              placeholder: (context, url) => ClipRRect(
                                  borderRadius: BorderRadius.circular(30.sp),
                                  child: Image.asset(
                                    'asset/bg_01.jpg',
                                    fit: BoxFit.cover,
                                  )),
                              imageUrl: widget.image,
                              fit: BoxFit.fitHeight,
                              height: 210.h,
                            );
                          },
                        ),
                      ),
                    ));
        });
  }
}

class CategoryTypeContent extends StatelessWidget {
  const CategoryTypeContent({
    super.key,
    required this.title,
  });
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 41.h,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: kblueColor,
      ),
      child: Center(
          child: Text(
        title,
        style: TextStyle(
            color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.bold),
      )),
    );
  }
}
