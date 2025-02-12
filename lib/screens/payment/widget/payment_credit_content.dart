import 'package:flutter/material.dart';
import 'package:templates_flutter_app/screens/payment/widget/credit_card_info.dart';
import 'package:templates_flutter_app/screens/payment/widget/payment_form.dart';
import 'package:templates_flutter_app/screens/suscription/model/suscription_model.dart';

class PaymentCreditContent extends StatelessWidget {
  const PaymentCreditContent({
    super.key,
    required this.suscription,
  });
  final SuscriptionModel suscription;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CreditCardInfo(),
        PaymentForm(
          suscription: suscription,
        )
      ],
    );
  }
}