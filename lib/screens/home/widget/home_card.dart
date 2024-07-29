import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/constants.dart';
import 'package:templates_flutter_app/screens/category/category_app.dart';
import 'package:templates_flutter_app/screens/home/services/home_data_services.dart';
import 'package:templates_flutter_app/screens/home/widget/card_label.dart';
import 'package:templates_flutter_app/screens/login/login_screen.dart';
import 'package:templates_flutter_app/screens/suscription/suscription_screen.dart';

// ignore: must_be_immutable
class HomeCard extends StatefulWidget {
  const HomeCard({super.key, required this.isLoggedIn});
  final bool isLoggedIn;
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
          return SizedBox(
            height: 110.h,
            child: GestureDetector(
              onTap: () async {
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
                      category,
                      widget.isLoggedIn);
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10.h),
                width: MediaQuery.of(context).size.width * .9,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.sp),
                ),
                child: Stack(children: [
                  imageUrl != null && isValidImageUrl(imageUrl)
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20.sp),
                          child: Image.network(
                            imageUrl,
                            height: 120.h,
                            width: MediaQuery.of(context).size.width * .9,
                            fit: BoxFit.cover,
                          ),
                        )
                      : AlertDialog(
                          title: const Text('No image available'),
                          content: const Text(
                              'The category does not have an associated image.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                  Align(
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
                  Positioned(
                      top: 40.h,
                      left: 220.w,
                      child: StreamBuilder<QuerySnapshot<Object?>>(
                          stream: FirebaseFirestore.instance
                              .collection('categories')
                              .where('category',
                                  isEqualTo: category['category'])
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            }
                            final data = snapshot.data!.docs.first;
                            final type = data['type'];
                            return CardLabel(type: type);
                          }))
                ]),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

void navigateToCategory(
    String type, BuildContext context, category, isLoggedIn) {
  if (type == 'Premium') {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (isLoggedIn) {
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
        } else {
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
        }
      },
    );
  } else if (type == 'Free') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Category(
          category: category['category'] as String,
        ),
      ),
    );
  }
}

/*
if (isLoggedIn) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Category(
                  category: category['category'] as String,
                ),
              ),
            );
          });
        }
 */

/*
isLoggedIn
                ? TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SuscriptionScreen(),
                        ),
                      );
                    },
                    child: const Text('Go to Subscription'),
                  )
                : TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                    child: const Text('Go to Subscription'),
                  ),
*/

/**
 *  bool isLoggedIn;
 */


/*
class HomeCard extends StatefulWidget {
  const HomeCard({super.key});

  @override
  State<HomeCard> createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  final HomeDataService _dataService = HomeDataService();
  List<Map<String, String>> selectCategory = [];

  @override
  void initState() {
    super.initState();
    _getDataCategory();
  }

  Future<void> _getDataCategory() async {
    final List<Map<String, String>> fetchcategories =
        await _dataService.getCategory();

    setState(() {
      selectCategory = fetchcategories;
    });
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
          return SizedBox(
            height: 110.h,
            child: GestureDetector(
              onTap: () async {
                final categorySnaphot = await FirebaseFirestore.instance
                    .collection('categories')
                    .where('category', isEqualTo: category['category'])
                    .get();
                if (categorySnaphot.docs.isNotEmpty) {
                  final data = categorySnaphot.docs.first.data();
                  final type = data['type'];
                  // ignore: use_build_context_synchronously
                  navigateToCategory(type, context, category);
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10.h),
                width: MediaQuery.of(context).size.width * .9,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.sp),
                ),
                child: Stack(children: [
                  imageUrl != null && isValidImageUrl(imageUrl)
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20.sp),
                          child: Image.network(
                            imageUrl,
                            height: 120.h,
                            width: MediaQuery.of(context).size.width * .9,
                            fit: BoxFit.cover,
                          ),
                        )
                      : AlertDialog(
                          title: const Text('No image available'),
                          content: const Text(
                              'The category does not have an associated image.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                  Align(
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
                  Positioned(
                      top: 40.h,
                      left: 220.w,
                      child: StreamBuilder<QuerySnapshot<Object?>>(
                          stream: FirebaseFirestore.instance
                              .collection('categories')
                              .where('category',
                                  isEqualTo: category['category'])
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            }
                            final data = snapshot.data!.docs.first;
                            final type = data['type'];
                            return CardLabel(type: type);
                          }))
                ]),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

void navigateToCategory(String type, context, category) {
  if (type == 'Premium') {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('This is a Premium Content'),
          content: const Text('Please Buy a Subscription'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SuscriptionScreen(),
                  ),
                );
              },
              child: const Text('Go to Subscription'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  } else if (type == 'Free') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Category(
          category: category['category'] as String,
        ),
      ),
    );
  }
}

 */