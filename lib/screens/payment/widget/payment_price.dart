import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/screens/suscription/model/suscription_model.dart';

class PaymenPrice extends StatelessWidget {
  const PaymenPrice({
    super.key,
    required this.suscription,
  });
  final SuscriptionModel suscription;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .76,
      height: 19.h,
      margin: EdgeInsets.only(bottom: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Price',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
          ),
          Text(
            '\$${suscription.price}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
          )
        ],
      ),
    );
  }
}
