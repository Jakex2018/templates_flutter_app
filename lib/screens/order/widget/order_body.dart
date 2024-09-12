import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/constants.dart';
import 'package:templates_flutter_app/screens/home/home_app.dart';
import 'package:templates_flutter_app/widget/button01.dart';

class OrderBody extends StatelessWidget {
  const OrderBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * .6,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('asset/finished.png', fit: BoxFit.contain),
                      Text(
                        'Order Complete',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30.sp),
                      ),
                      Text(
                        'See you templates',
                        style: TextStyle(
                            fontWeight: FontWeight.w100, fontSize: 20.sp),
                      )
                    ],
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 30.h),
                  height: MediaQuery.of(context).size.height * .2,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      ButtonOne(
                        text: 'View your ticket',
                        onPressed: () {},
                        backgroundColor: kpurpleColor,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Home(),
                                ));
                          },
                          child: Text(
                            'Back to home',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20.sp,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer),
                          ))
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
