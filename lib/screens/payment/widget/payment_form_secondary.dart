import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/constants.dart';

class PaymentFormSecondary extends StatelessWidget {
  const PaymentFormSecondary({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            height: 55.h,
            padding: EdgeInsets.symmetric(vertical: 20.h),
            width: MediaQuery.of(context).size.width * .4,
            decoration: BoxDecoration(
                border: Border.all(color: kpurpleColor),
                borderRadius: BorderRadius.circular(10.sp)),
            child: Center(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: '12/23',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
                  labelStyle: const TextStyle(color: Colors.black26),
                  fillColor: Colors.white,
                  filled: true,
                  suffixIcon: Icon(
                    Icons.verified,
                    color: kpurpleColor,
                    size: 20.sp,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20.sp),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
            left: 40,
            right: 38,
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  'Expiration Date',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 7.sp,
                    color: Colors.black,
                  ),
                ),
              ),
            ))
      ],
    );
  }
}
