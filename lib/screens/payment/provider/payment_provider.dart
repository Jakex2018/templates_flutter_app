import 'package:flutter/material.dart';
import 'package:templates_flutter_app/screens/payment/model/payment_model.dart';

enum PaymentOp { paypal, stripe }

class PaymentMethodProvider extends ChangeNotifier {
  PaymentOp? _paymentMethod;

  PaymentOp? get paymentMethod => _paymentMethod;

  void setPaymentMethod(PaymentOp method) {
    _paymentMethod = method;
    notifyListeners();
  }
}
