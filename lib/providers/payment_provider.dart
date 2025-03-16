import 'package:flutter/material.dart';

enum PaymentOp { paypal, stripe }

class PaymentMethodProvider extends ChangeNotifier {
  PaymentOp? _paymentMethod;

  PaymentOp? get paymentMethod => _paymentMethod;

  void setPaymentMethod(PaymentOp method) {
    _paymentMethod = method;
    notifyListeners();
  }
}
