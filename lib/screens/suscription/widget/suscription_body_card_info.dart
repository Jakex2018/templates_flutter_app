import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/constants.dart';
import 'package:templates_flutter_app/screens/payment/payment_screen.dart';
import 'package:templates_flutter_app/widget/button01.dart';

class SuscriptionBodyCardInfo extends StatelessWidget {
  const SuscriptionBodyCardInfo({
    super.key,
    required this.item,
  });
  final Map<dynamic, dynamic> item;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
                vertical: aDefaultPadding / 2.8,
                horizontal: aDefaultPadding / 4),
            height: 80.h,
            width: MediaQuery.of(context).size.width * .7,
            decoration: BoxDecoration(
              color: kpurpleColor,
              borderRadius: BorderRadius.circular(20.sp),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                item['icon'] ?? '' as Icon,
                SizedBox(width: aDefaultPadding - 5.w),
                Text(
                  item['title'] ?? '',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp),
                )
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * .5,
            width: MediaQuery.of(context).size.width * .7,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 80.h),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              item['items']['items01'],
                              height: 30.h,
                            ),
                            Text(
                              item['desc']['desc01'],
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Image.asset(
                              item['items']['items02'],
                              height: 30.h,
                            ),
                            Text(
                              item['desc']['desc02'],
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Image.asset(
                              item['items']['items03'],
                              height: 30.h,
                            ),
                            Text(
                              item['desc']['desc03'],
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ],
                        )
                      ]),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50.h),
                  child: ButtonOne(
                    text: 'Default',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PaymentScreen()));
                    },
                    width: 130,
                    height: 40,
                    margin: 0,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}


/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/constants.dart';
import 'package:templates_flutter_app/widget/button01.dart';

class SuscriptionBodyCardInfo extends StatelessWidget {
  const SuscriptionBodyCardInfo({
    super.key,
    required this.item,
  });
  final Map<dynamic, dynamic> item;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
              vertical: aDefaultPadding / 2.8, horizontal: aDefaultPadding / 4),
          height: 80.h,
          width: MediaQuery.of(context).size.width * .7,
          decoration: BoxDecoration(
            color: kpurpleColor,
            borderRadius: BorderRadius.circular(20.sp),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              item['icon'] ?? '' as Icon,
              SizedBox(width: aDefaultPadding - 5.w),
              Text(
                item['title'] ?? '',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp),
              )
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * .1,
          width: MediaQuery.of(context).size.width * .8,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(children: [
                Row(
                  children: [
                    Image.asset(item['items']['items01'],height: 30.h,),
                    Text(item['desc']['desc01'],style: TextStyle(fontSize: 14.sp),),
                  ],
                ),
                Row(
                  children: [
                    Image.asset(item['items']['items02'],height: 30.h,),
                    Text(item['desc']['desc02'],style: TextStyle(fontSize: 14.sp),),
                  ],
                ),
                Row(
                  children: [
                    Image.asset(item['items']['items03'],height: 30.h,),
                    Text(item['desc']['desc03'],style: TextStyle(fontSize: 14.sp),),
                  ],
                )
              ]),
              Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: ButtonOne(
                  text: 'Default',
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Container()));
                  },
                  width: 130,
                  height: 20,
                  margin: 0,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

 */