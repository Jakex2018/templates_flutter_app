import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/constants.dart';
import 'package:templates_flutter_app/screens/category/category_app.dart';
import 'package:templates_flutter_app/screens/home/services/home_data_services.dart';
import 'package:templates_flutter_app/screens/home/widget/splash_subscribe.dart';
import 'package:templates_flutter_app/screens/auth/login/login_screen.dart';
import 'package:templates_flutter_app/screens/auth/model/user_model.dart';
import 'package:templates_flutter_app/screens/suscription/provider/suscription_provider.dart';
import 'package:templates_flutter_app/screens/suscription/suscription_screen.dart';

// ignore: must_be_immutable

class HomeCard extends StatefulWidget {
  const HomeCard({super.key});

  @override
  State<HomeCard> createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  final HomeDataService _dataService = HomeDataService();
  List<Map<String, String>> selectCategory = [];
  bool _mounted = true;
  @override
  void initState() {
    super.initState();
    _mounted = true;
    _getDataCategory();
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  Future<void> _getDataCategory() async {
    final List<Map<String, String>> fetchcategories =
        await _dataService.getCategory();

    if (_mounted) {
      setState(() {
        selectCategory = fetchcategories;
      });
    }
  }

  bool isValidImageUrl(String url) {
    final RegExp urlRegex = RegExp(
      r'(https?://)?[^\s]+?\.(jpg|jpeg|png|gif|webp)(\?\S*)?',
    );
    return urlRegex.hasMatch(url);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: aDefaultPadding / 2,
        vertical: aDefaultPadding,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: selectCategory.map((category) {
          final String? imageUrl = category['imageCategory'];
          final categoryStream = HomeDataService().typeCat;
          return homeCardBody(category, context, imageUrl, categoryStream);
        }).toList(),
      ),
    );
  }

  Widget homeCardBody(
      Map<String, String> category,
      BuildContext context,
      String? imageUrl,
      StreamBuilder<QuerySnapshot<Object?>> Function(
              Map<String, String> category)
          categoryStream) {
    return SizedBox(
      height: 150.h,
      child: GestureDetector(
        onTap: () async {
          final String? imageUrl = category['imageCategory'];
          if (imageUrl == null || imageUrl.isEmpty) {
            dialogImageNot(context);
            return;
          }
          final categorySnaphot = await FirebaseFirestore.instance
              .collection('categories')
              .where('category', isEqualTo: category['category'])
              .get();
          if (categorySnaphot.docs.isNotEmpty) {
            final data = categorySnaphot.docs.first.data();
            final type = data['type'];
            // ignore: use_build_context_synchronously
            navigateToCategory(
                // ignore: use_build_context_synchronously
                type,
                // ignore: use_build_context_synchronously
                context,
                category);
          }
        },
        child: homeCardItems(context, imageUrl, category, categoryStream),
      ),
    );
  }

  Widget homeCardItems(
      BuildContext context,
      String? imageUrl,
      Map<String, String> category,
      StreamBuilder<QuerySnapshot<Object?>> Function(
              Map<String, String> category)
          categoryStream) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      width: MediaQuery.of(context).size.width * .9,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.sp),
      ),
      child: Stack(children: [
        imageUrl != null && isValidImageUrl(imageUrl)
            ? ClipRRect(
                borderRadius: BorderRadius.circular(30.sp),
                child: Stack(children: [
                  CachedNetworkImage(
                    imageUrl: imageUrl,
                    placeholder: (context, url) => Container(
                        height: 15.h,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)),
                        child:
                            const Center(child: CircularProgressIndicator())),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    height: 125.h,
                    width: MediaQuery.of(context).size.width * .9,
                    fit: BoxFit.cover,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 129.h,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(30.sp),
                      ),
                      child: Center(
                        child: Text(
                          category['category'] as String,
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              )
            : Align(
                alignment: Alignment.center,
                child: Container(
                  height: 120.h,
                  width: MediaQuery.of(context).size.width * .9,
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(20.sp),
                  ),
                  child: Center(
                    child: Text(
                      'No Image Avaivable',
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
        Positioned(top: 40.h, left: 220.w, child: categoryStream(category))
      ]),
    );
  }

  Future<dynamic> dialogImageNot(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('No Image Available'),
          content: const Text('This category does not have an image.'),
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

  void navigateToCategory(
      String type, BuildContext context, Map<String, String> category) {
    final authProvider = Provider.of<AuthUserProvider>(context, listen: false);
    final subscriptionProvider =
        Provider.of<SuscriptionProvider>(context, listen: false);

    if (type == 'Premium') {
      if (authProvider.isLogged) {
        if (subscriptionProvider.isSuscribed) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SplashSuscribe(
                      titleSuscription: 'Contratulations Are you Member!!!',
                      category: category,
                      widgetScreen: Category(
                        type: 'Premium',
                        category: category['category'] as String,
                      ),
                    )),
          );
        } else {
          __showPremiumDialog(context);
        }
      } else {
        __showLoginDialog(context);
      }
    } else if (type == 'Free') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Category(
            type: 'Free',
            category: category['category'] as String,
          ),
        ),
      );
    }
  }

  Future<dynamic> __showLoginDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('This is a Premium Content'),
            content: const Text('Please Login your account'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      ));
                },
                child: const Text('Go to Login'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          );
        });
  }

  Future<dynamic> __showPremiumDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('This is a Premium Content'),
          content: const Text('Please Buy a Subscription'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SuscriptionScreen(),
                    ));
              },
              child: const Text('Go to Subscription'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
