import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/screens/home/home_app.dart';
import 'package:templates_flutter_app/screens/suscription/provider/suscription_provider.dart';
import 'package:dio/dio.dart';

class UserPayServices {
  UserPayServices._();
  static final UserPayServices instance = UserPayServices._();
  Map<String, dynamic>? paymentIntent;

  Future<void> makePayment(context) async {
    try {
      //STEP 1: Create a payment intent
      paymentIntent = await createPaymentIntent('3', 'USD');
      print(paymentIntent?['client_secret']);

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  googlePay:
                      const PaymentSheetGooglePay(merchantCountryCode: ''),
                  paymentIntentClientSecret: paymentIntent?[
                      'client_secret'], //Gotten from payment intent
                  style: ThemeMode.dark,
                  merchantDisplayName: 'Neha Tanwar'))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet(context);
    } catch (err) {
      throw Exception(err);
    }
  }

  displayPaymentSheet(context) async {
    print("displayPaymentSheet fn calling");
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        userPay(context);
        paymentIntent = null;
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text("Payment Failed"),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      print('payment cancelled-------------$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    final Dio dio = Dio();
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };

      //Make post request to Stripe
      var response = await dio.post(
        'https://api.stripe.com/v1/payment_intents',
        options: Options(
          headers: {
            'Authorization':
                'Bearer sk_test_51QzRAkQjQlDsnuwCLQFQF1OISHazc7KtyXJV0lFmwo6GzH3xejFfvMGxMeKyv0KSPwu1tlYzYvAjyGM3DzwYFWuS00fqKK9lTR',
            'Content-Type': 'application/x-www-form-urlencoded'
          },
        ),
        data: body,
      );
      return response.data;
    } catch (err) {
      print("payment intent---------_${err.toString()}");
      throw Exception(err.toString());
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }

  Future<void> userPay(BuildContext context) async {
    final subscriptionProvider =
        Provider.of<SuscriptionProvider>(context, listen: false);

    final auth = FirebaseAuth.instance;
    final userId = auth.currentUser?.uid;

    //save subscribe
    if (userId != null) {
      final expiryTime = DateTime.now().add(const Duration(seconds: 20));

      final nowTime = DateTime.now();

      await subscriptionProvider.activateSubscription(
          userId, true, nowTime, expiryTime);
    }

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Home()));
    showDialog(
        context: context,
        builder: (_) => const AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 100.0,
                  ),
                  SizedBox(height: 10.0),
                  Text("Payment Successful!"),
                ],
              ),
            ));
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
                "item_list": {
                  "items": [
                    {
                      "name": "A demo product",
                      "quantity": 1,
                      "price": '1.00',
                      "currency": "USD"
                    }
                  ],
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
              userPay(context);
              return;
            },
            onError: (error) {
              throw Exception("onError: $error");
            },
            onCancel: (params) {
              throw Exception('cancelled: $params');
            }),
      ),
    );
  }
}