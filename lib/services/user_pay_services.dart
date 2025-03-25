import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/views/home_app.dart';
import 'package:templates_flutter_app/providers/suscription_provider.dart';
import 'package:dio/dio.dart';

class UserPayServices {
  UserPayServices._();
  static final UserPayServices instance = UserPayServices._();
  Map<String, dynamic>? paymentIntent;

  Future<void> makePayment(context) async {
    try {
      //STEP 1: Create a payment intent
      paymentIntent = await createPaymentIntent('3', 'USD');

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
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        paymentIntent = null;
        userPay(context);
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException {
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
      rethrow;
    } catch (e) {
      rethrow;
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
      final expiryTime = DateTime.now().add(const Duration(minutes: 5));

      final nowTime = DateTime.now();

      await subscriptionProvider.activateSubscription(
          userId, true, nowTime, expiryTime);
    }

    if (context.mounted) {
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
  }

  Future navigatePaypal(BuildContext context) {
    return Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => PaypalCheckoutView(
        sandboxMode: true,
        clientId:
            "AW7ZVMhJA75HiY7skZuen5ZHbGucjUprVuoYok9oREZe9izpxfInQ1mXoPFSslyIjrQJGZX_mBSNSnTL",
        secretKey:
            "ECmecZWJF9LRi84D0Sz0GRZ2rPh7ttP5a7cRUA_m-d5S0s9Ve9fzCmbNCsW7StEeMzJB_KA6V9_3vIq9",
        transactions: const [
          {
            "amount": {
              "total": '3',
              "currency": "USD",
              "details": {
                "subtotal": '3',
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
                  "name": "Templates Suscription",
                  "quantity": 1,
                  "price": '3',
                  "currency": "USD"
                },
              ],

              // shipping address is not required though
              //   "shipping_address": {
              //     "recipient_name": "tharwat",
              //     "line1": "Alexandria",
              //     "line2": "",
              //     "city": "Alexandria",
              //     "country_code": "EG",
              //     "postal_code": "21505",
              //     "phone": "+00000000",
              //     "state": "Alexandria"
              //  },
            }
          }
        ],
        note: "Contact us for any questions on your order.",
        onSuccess: (Map params) async {
          await userPay(context);
        },
        onError: (error) {
          Navigator.pop(context);
        },
        onCancel: () {
          Navigator.pop(context);
        },
      ),
    ));
  }
}
