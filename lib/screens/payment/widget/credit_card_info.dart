import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/screens/payment/payment_screen.dart';
import 'package:templates_flutter_app/screens/suscription/model/payment_model.dart';

class CreditCardInfo extends StatelessWidget {
  const CreditCardInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final paymentMethodProvider = Provider.of<PaymentMethodProvider>(context);
    return Container(
      height: 70.h,
      margin: EdgeInsets.symmetric(vertical: 0.h),
      width: MediaQuery.of(context).size.width * .8,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          PaymentCreditOption(
            selected: paymentMethodProvider.paymentMethod == PaymentMethod.card,
            paymentMethod: PaymentMethod.card,
          ),
          const SizedBox(width: 16),
          const Text('Credit or debit card',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(width: 16),
          Image.asset('asset/credit-card.png', fit: BoxFit.cover),
        ],
      ),
    );
  }
}
