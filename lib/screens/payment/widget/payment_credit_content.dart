// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/constants.dart';
import 'package:templates_flutter_app/main.dart';
import 'package:templates_flutter_app/screens/payment/payment_screen.dart';
import 'package:templates_flutter_app/screens/payment/services/user_pay_services.dart';
import 'package:templates_flutter_app/screens/payment/widget/payment_paypal.dart';
import 'package:templates_flutter_app/screens/payment/widget/payment_price.dart';
import 'package:templates_flutter_app/screens/suscription/model/payment_model.dart';
import 'package:templates_flutter_app/screens/suscription/model/suscription_model.dart';
import 'package:templates_flutter_app/widget/button01.dart';

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
        creditCartInfo(context),
        PaymentForm(
          suscription: suscription,
        )
      ],
    );
  }

  Container creditCartInfo(BuildContext context) {
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
              selected:
                  paymentMethodProvider.paymentMethod == PaymentMethod.card,
              paymentMethod: PaymentMethod.card,
            ),
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

class PaymentForm extends StatefulWidget {
  const PaymentForm({super.key, required this.suscription});
  final SuscriptionModel suscription;
  @override
  State<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  @override
  void dispose() {
    super.dispose();
    // Cancel any subscriptions or timers here
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  @override
  Widget build(BuildContext context) {
    final paymentModel = Provider.of<Paymentmodel>(context);
    void userPayment(BuildContext context) {
      if (formKey.currentState!.validate()) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Confirm payment"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text("Card Number:$cardNumber"),
                  Text("Expiry Date:$expiryDate"),
                  Text("Card Holder name:$cardHolderName"),
                  Text("CVV:$cvvCode")
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    userPay(context);
                  },
                  child: const Text('Yes'))
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Payment Error"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel')),
            ],
          ),
        );
      }
    }

    return Column(
      children: [
        CreditCardForm(
          formKey: formKey,
          cardNumber: cardNumber,
          expiryDate: expiryDate,
          cardHolderName: cardHolderName,
          cvvCode: cvvCode,
          onCreditCardModelChange: (item) {
            setState(() {
              cardNumber = item.cardNumber;
              expiryDate = item.expiryDate;
              cardHolderName = item.cardHolderName;
              cvvCode = item.cvvCode;
            });
          },
          cvvValidationMessage: 'Please input a valid CVV',
          dateValidationMessage: 'Please input a valid date',
          numberValidationMessage: 'Please input a valid number',
          obscureCvv: true,
          inputConfiguration: InputConfiguration(
            cardNumberDecoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              labelText: 'Number',
              hintText: 'XXXX XXXX XXXX XXXX',
            ),
            expiryDateDecoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              labelText: 'Expired Date',
              hintText: 'XX/XX',
            ),
            cvvCodeDecoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              labelText: 'CVV',
              hintText: 'XXX',
            ),
            cardHolderDecoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              labelText: 'Card Holder',
            ),
            cardNumberTextStyle: TextStyle(
                fontSize: 15,
                color: Theme.of(context).colorScheme.inversePrimary),
            cardHolderTextStyle: TextStyle(
                fontSize: 15,
                color: Theme.of(context).colorScheme.inversePrimary),
            expiryDateTextStyle: TextStyle(
                fontSize: 15,
                color: Theme.of(context).colorScheme.inversePrimary),
            cvvCodeTextStyle: TextStyle(
                fontSize: 15,
                color: Theme.of(context).colorScheme.inversePrimary),
          ),
        ),
        const PaymentPaypal(),
        PaymenPrice(
          suscription: widget.suscription,
        ),
        ButtonOne(
          text: 'PLACE ORDER',
          onPressed: () async {
            final activeProvider =
                Provider.of<PaymentMethodProvider>(context, listen: false);
            if (activeProvider.paymentMethod ==
                paymentModel.activePaymentMethod) {
              switch (activeProvider.paymentMethod) {
                case PaymentMethod.card:
                  userPayment(context);

                  break;
                case PaymentMethod.paypal:
                  navigatePaypal(
                    context,
                  ).then((_) {
                    if (mounted) {
                      // ignore: use_build_context_synchronously
                      userPay(context);
                    }
                  });
                default:
              }
            }
            //FlutterBackgroundService().invoke("setAsForeground");
            //userPay(context);
          },
          backgroundColor: kpurpleColor,
        )
      ],
    );
  }

  Future navigatePaypal(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => UsePaypal(
            sandboxMode: true,
            clientId:
                "AW7ZVMhJA75HiY7skZuen5ZHbGucjUprVuoYok9oREZe9izpxfInQ1mXoPFSslyIjrQJGZX_mBSNSnTL",
            secretKey:
                "ECmecZWJF9LRi84D0Sz0GRZ2rPh7ttP5a7cRUA_m-d5S0s9Ve9fzCmbNCsW7StEeMzJB_KA6V9_3vIq9",
            returnURL: "https://samplesite.com/return",
            cancelURL: "https://samplesite.com/cancel",
            transactions: const [
              {
                "amount": {
                  "total": '1.00',
                  "currency": "USD",
                  "details": {
                    "subtotal": '1.00',
                    "shipping": '0',
                    "shipping_discount": 0
                  }
                },
                "description": "The payment transaction description.",
                // "payment_options": {
                //   "allowed_payment_method":
                //       "INSTANT_FUNDING_SOURCE"
                // },
                "item_list": {
                  "items": [
                    {
                      "name": "A demo product",
                      "quantity": 1,
                      "price": '1.00',
                      "currency": "USD"
                    }
                  ],

                  // shipping address is not required though
                  "shipping_address": {
                    "recipient_name": "Jane Foster",
                    "line1": "Travis County",
                    "line2": "",
                    "city": "Austin",
                    "country_code": "US",
                    "postal_code": "73301",
                    "phone": "+00000000",
                    "state": "Texas"
                  },
                }
              }
            ],
            note: "Contact us for any questions on your order.",
            onSuccess: (Map params) async {
              print("onSuccess: $params");
              dialogi();
            },
            onError: (error) {
              print("onError: $error");
            },
            onCancel: (params) {
              print('cancelled: $params');
            }),
      ),
    );
  }
}
