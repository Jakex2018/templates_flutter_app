import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/screens/payment/payment_screen.dart';
import 'package:templates_flutter_app/screens/suscription/model/payment_model.dart';

class PaymentPaypal extends StatelessWidget {
  const PaymentPaypal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final paymentMethodProvider = Provider.of<PaymentMethodProvider>(context);
    return Container(
      height: 126.h,
      margin: EdgeInsets.symmetric(vertical: 10.h),
      width: MediaQuery.of(context).size.width * .76,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PaymentCreditOption(
                selected:
                    paymentMethodProvider.paymentMethod == PaymentMethod.card,
                paymentMethod: PaymentMethod.paypal,
              ),
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
