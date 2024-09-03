import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/constants.dart';
import 'package:templates_flutter_app/screens/error/error_screen.dart';
import 'package:templates_flutter_app/screens/home/widget/home_card.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// ignore: must_be_immutable
class HomeContent extends StatefulWidget {
  const HomeContent({super.key, required this.isLoggedIn});
  final bool isLoggedIn;

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  bool showProgress = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        showProgress = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error de conectividad');
          }

          return Container(
            height: MediaQuery.of(context).size.height * .7,
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).colorScheme.background,
            child: SingleChildScrollView(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: aDefaultPadding * .9),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      snapshot.data != ConnectivityResult.none
                          ? HomeCard(isLoggedIn: widget.isLoggedIn)
                          : Stack(children: [
                              showProgress
                                  ? Center(
                                      child: Container(
                                        margin: EdgeInsets.only(top: 200.h),
                                        width: 50,
                                        height: 50,
                                        child:
                                            const CircularProgressIndicator(),
                                      ),
                                    )
                                  : SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .5,
                                      child: const Center(child: ErrorPage()),
                                    ),
                            ])
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

/*
const Center(
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(),
                            ),
                          )
 */

