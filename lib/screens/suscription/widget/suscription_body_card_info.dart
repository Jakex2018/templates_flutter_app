/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/constants.dart';
import 'package:templates_flutter_app/screens/payment/payment_screen.dart';
import 'package:templates_flutter_app/screens/suscription/model/suscription_model.dart';
import 'package:templates_flutter_app/widget/button01.dart';

class SuscriptionBodyCardInfo extends StatelessWidget {
  const SuscriptionBodyCardInfo({
    super.key,
    required this.item,
    required this.suscription,
  });
  final SuscriptionModel suscription;
  final Map<dynamic, dynamic> item;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [suscriptionCardSup(context), suscriptionCardInf(context)],
      ),
    );
  }

  Container suscriptionCardInf(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .5,
      width: MediaQuery.of(context).size.width * .7,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 80.h),
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
                        style: TextStyle(fontSize: 14.sp, color: Colors.black),
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
                        style: TextStyle(fontSize: 14.sp, color: Colors.black),
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
                        style: TextStyle(fontSize: 14.sp, color: Colors.black),
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
                        builder: (context) => PaymentScreen(
                              suscription: suscription,
                            )));
              },
              backgroundColor: kpurpleColor,
            ),
          )
        ],
      ),
    );
  }

  Container suscriptionCardSup(BuildContext context) {
    return Container(
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
    );
  }
}

 */