import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/constants.dart';
import 'package:templates_flutter_app/screens/suscription/widget/suscription_body_card_info.dart';
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
        height: MediaQuery.of(context).size.height * .7,
        width: MediaQuery.of(context).size.width * .8,
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: kpurpleColor, width: 10),
            borderRadius: BorderRadius.circular(20.sp),
            boxShadow: [
              BoxShadow(
                  blurRadius: 5.sp,
                  offset: Offset(0, 5.sp),
                  color: Colors.black,
                  spreadRadius: 2.sp)
            ]),
        child: SuscriptionBodyCardInfo(item: item),
      ),
    );
  }
}

List<Map> infoCard = [
  {
    'icon': const Icon(Icons.coffee, size: 50, color: Colors.white),
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
