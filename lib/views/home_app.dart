import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/providers/auth_user_provider.dart';
import 'package:templates_flutter_app/services/initialize_providers.dart';
import 'package:templates_flutter_app/common/constants/constants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:templates_flutter_app/views/sidebar_screen.dart';
import 'package:templates_flutter_app/widget/custom_app_bar.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/views/category_app.dart';
import 'package:templates_flutter_app/services/home_data_services.dart';
import 'package:templates_flutter_app/widget/splash_subscribe.dart';
import 'package:templates_flutter_app/views/login_screen.dart';
import 'package:templates_flutter_app/providers/suscription_provider.dart';
import 'package:templates_flutter_app/views/suscription_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = true;
  String username = "";

  @override
  void initState() {
    super.initState();
    initializeProviders(context);
    _simulateLoading();
  }

  Future<void> _simulateLoading() async {
    await Future.delayed(Duration(seconds: 3));
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthUserProvider>(context);
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Stack(
      children: [
        if (isLoading) _buildLoadScreen(context),
        if (!isLoading) _buildHomeContent(scaffoldKey, authProvider),
      ],
    );
  }

  Scaffold _buildHomeContent(
      GlobalKey<ScaffoldState> scaffoldKey, AuthUserProvider authProvider) {
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(onTap: () => scaffoldKey.currentState!.openDrawer()),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            HomeTypeContent(title: 'Choose a Category'),
            HomeContent(),
          ],
        ),
      ),
      drawer: Sidebar(isLoggedIn: authProvider, username: username),
    );
  }

  Container _buildLoadScreen(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).colorScheme.surface,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

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

class HomeContent extends StatefulWidget {
  const HomeContent({
    super.key,
  });

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeInAnimation;

  bool showProgress = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _fadeInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          showProgress = false;
        });
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
      stream:
          Connectivity().onConnectivityChanged.map((results) => results.first),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error de conectividad');
        }

        return Container(
          height: MediaQuery.of(context).size.height * .8,
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).colorScheme.surface,
          child: SingleChildScrollView(
            child: Container(
              margin:
                  const EdgeInsets.symmetric(vertical: aDefaultPadding * .9),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeInAnimation,
                    child: SlideTransition(
                      position: _offsetAnimation,
                      child: const HomeCard(),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class HomeTypeContent extends StatelessWidget {
  const HomeTypeContent({
    super.key,
    required this.title,
  });
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 41.h,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onTertiary,
        border: Border.all(color: Colors.white12),
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
