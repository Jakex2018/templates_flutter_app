import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/constants.dart';
import 'package:templates_flutter_app/screens/payment/payment_screen.dart';
import 'package:templates_flutter_app/widget/button01.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SuscriptionBody extends StatelessWidget {
  const SuscriptionBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(height: MediaQuery.of(context).size.height * .9),
      items: infoCard
          .map((item) => _buildSubscriptionCard(item, context))
          .toList(),
    );
  }

  Widget _buildSubscriptionCard(Map<dynamic, dynamic> item, context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * .789,
        width: MediaQuery.of(context).size.width * .8,
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: kpurpleColor, width: 10),
          borderRadius: BorderRadius.circular(20.sp),
        ),
        child: SuscriptionBodyCardInfo(item: item),
      ),
    );
  }
}

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
          height: 160.h,
          width: MediaQuery.of(context).size.width * .7,
          decoration: BoxDecoration(
            color: kpurpleColor,
            borderRadius: BorderRadius.circular(20.sp),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              item['icon'] ?? '' as Icon,
              SizedBox(width: aDefaultPadding - 5.w),
              Text(
                item['title'] ?? '',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.sp),
              )
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * .5,
          width: MediaQuery.of(context).size.width * .8,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(children: [
                Row(
                  children: [
                    Image.asset(item['items']['items01']),
                    Text(item['desc']['desc01']),
                  ],
                ),
                Row(
                  children: [
                    Image.asset(item['items']['items02']),
                    Text(item['desc']['desc02']),
                  ],
                ),
                Row(
                  children: [
                    Image.asset(item['items']['items03']),
                    Text(item['desc']['desc03']),
                  ],
                )
              ]),
              Padding(
                padding: EdgeInsets.only(bottom: 40.h),
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
    );
  }
}

List<Map> infoCard = [
  {
    'icon': const Icon(Icons.coffee, size: 100, color: Colors.white),
    'title': 'Free',
    'items': {
      'items01': 'asset/verify.png',
      'items02': 'asset/verify.png',
      'items03': 'asset/verify.png',
    },
    'desc': {
      'desc01': 'Templates Free',
      'desc02': 'Limitated Chat Bot',
      'desc03': '5 Coins for day IA Chat Bot'
    }
  },
  {
    'icon': const Icon(
      Icons.rocket,
      size: 100,
      color: Colors.white,
    ),
    'title': 'Premium',
    'items': {
      'items01': 'asset/verify.png',
      'items02': 'asset/verify.png',
      'items03': 'asset/verify.png',
    },
    'desc': {
      'desc01': 'Templates Premium',
      'desc02': 'Ilimitated Chat Bot',
      'desc03': 'Ilimitates coins IA Chat Bot'
    }
  },
];
