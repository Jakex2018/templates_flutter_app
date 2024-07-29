import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/constants.dart';
import 'package:templates_flutter_app/screens/order/order_screen.dart';
import 'package:templates_flutter_app/widget/button01.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Payment Method'),
          centerTitle: true,
        ),
        body: const PaymentBody());
  }
}

class PaymentBody extends StatelessWidget {
  const PaymentBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * .85,
        width: MediaQuery.of(context).size.width,
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
        child: Column(
          children: [
            const PaymentCreditContent(),
            const PaymentForm(),
            const PaymentSave(),
            const PaymentPaypal(),
            const PaymenPrice(),
            ButtonOne(
                text: 'PLACE ORDER',
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OrderScreen()));
                },
                width: MediaQuery.of(context).size.width * .8,
                height: 30.h,
                margin: 0)
          ],
        ),
      ),
    );
  }
}

class PaymenPrice extends StatelessWidget {
  const PaymenPrice({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .76,
      height: 19.h,
      margin: EdgeInsets.only(bottom: 40.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Price',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
          ),
          Text(
            '\$4.00',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
          )
        ],
      ),
    );
  }
}

class PaymentPaypal extends StatelessWidget {
  const PaymentPaypal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 126.h,
      margin: EdgeInsets.symmetric(vertical: 20.h),
      width: MediaQuery.of(context).size.width * .76,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const PaymentCreditOption(),
              SizedBox(width: 30.w),
              Text(
                'Buy now, and pay later\nwith Paypal',
                style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.bold,
                    fontSize: 17.sp),
              )
            ],
          ),
          SizedBox(height: 4.h),
          Image.asset('asset/paypal.png', fit: BoxFit.fitHeight)
        ],
      ),
    );
  }
}

class PaymentSave extends StatelessWidget {
  const PaymentSave({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55.h,
      width: MediaQuery.of(context).size.width * .9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            Icons.check_box_rounded,
            color: kpurpleColor,
            size: 30.sp,
          ),
          const Text(
            'Save payment details to your eventify\naccount(optional)',
            style:
                TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}

class PaymentForm extends StatelessWidget {
  const PaymentForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 55.h,
            width: MediaQuery.of(context).size.width * .82,
            decoration: BoxDecoration(
                border: Border.all(color: kpurpleColor),
                borderRadius: BorderRadius.circular(10.sp)),
            child: Center(
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: '1111 2222 3333 4444',
                        labelStyle: const TextStyle(color: Colors.black26),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20.sp),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.verified,
                      color: kpurpleColor,
                      size: 20.sp,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Image.asset('asset/mastercard.png'),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 30.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const PaymentFormSecondary(),
              SizedBox(
                width: 7.w,
              ),
              const PaymentFormSecondary(),
            ],
          ),
        ],
      ),
    );
  }
}

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
            top: 0,
            left: 40,
            bottom: 50,
            right: 38,
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Text(
                  'Expiration Date',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 8.sp),
                ),
              ),
            ))
      ],
    );
  }
}

class PaymentCreditContent extends StatelessWidget {
  const PaymentCreditContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      margin: EdgeInsets.symmetric(vertical: 0.h),
      width: MediaQuery.of(context).size.width * .8,
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const PaymentCreditOption(),
            SizedBox(
              width: 16.w,
            ),
            Text('Credit or debit card',
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
            SizedBox(
              width: 16.w,
            ),
            Image.asset('asset/credit-card.png', fit: BoxFit.cover)
          ]),
    );
  }
}

class PaymentCreditOption extends StatelessWidget {
  const PaymentCreditOption({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.h,
      width: 20.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50.sp)),
          color: Colors.white,
          border: Border.all(width: 2.w, color: Colors.black12)),
      child: Center(
        child: Container(
          height: 10.h,
          width: 10.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50.sp)),
            color: kpurpleColor,
          ),
        ),
      ),
    );
  }
}
