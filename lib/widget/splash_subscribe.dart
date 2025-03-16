import 'dart:async';
import 'package:flutter/material.dart';
import 'package:templates_flutter_app/common/constants/constants.dart';

class SplashSuscribe extends StatefulWidget {
  const SplashSuscribe(
      {super.key,
      this.category,
      required this.widgetScreen,
      required this.titleSuscription});
  final Map<String, String>? category;
  final Widget widgetScreen;
  final String titleSuscription;
  @override
  State<SplashSuscribe> createState() => _SplashSuscribeState();
}

class _SplashSuscribeState extends State<SplashSuscribe> {
  late Timer _timer;
  int _start = 3;
  @override
  void initState() {
    super.initState();
    //redirect();
    _startTimer(widget.category);
  }

  void _startTimer(category) {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_start == 0) {
        timer.cancel();
        if (mounted) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => widget.widgetScreen));
        }
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
        Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: aDefaultPadding * 2.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.titleSuscription,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.w300),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  child: Text(
                    'Loading Templates.....',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Text(
                  'Redirecting in $_start seconds...',
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
