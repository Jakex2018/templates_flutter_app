import 'package:flutter/material.dart';

enum PaymentMethod { card, paypal }

class PaymentMethodModel {
  final PaymentMethod payment;
  final String name; // Optional: Display name for the payment method

  const PaymentMethodModel({required this.payment, required this.name});
}

final List<PaymentMethodModel> paymentMethods = [
  const PaymentMethodModel(
      payment: PaymentMethod.card, name: 'Credit/Debit Card'),
  const PaymentMethodModel(payment: PaymentMethod.paypal, name: 'PayPal'),
];

class PaymentMethodProvider extends ChangeNotifier {
  PaymentMethod? _paymentMethod;

  PaymentMethod? get paymentMethod => _paymentMethod;

  void setPaymentMethod(PaymentMethod method) {
    _paymentMethod = method;
    notifyListeners();
  }
}

class Paymentmodel with ChangeNotifier {
  PaymentMethod _activePaymentMethod = PaymentMethod.card;

  PaymentMethod get activePaymentMethod => _activePaymentMethod;

  void setActive(PaymentMethod paymentMethod) {
    _activePaymentMethod = paymentMethod;
    notifyListeners();
  }
}

class PaymentProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKey;
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';

  PaymentProvider({
    required this.formKey,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cvvCode,
  });

  void userPayment(
      formKey, context, cardNumber, expiryDate, cardHolderName, cvvCode) {
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
            TextButton(onPressed: () {}, child: const Text('Yes'))
          ],
        ),
      );
    }
  }
}
