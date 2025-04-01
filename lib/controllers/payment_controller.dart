import 'package:flutter/material.dart';
import 'package:templates_flutter_app/models/payment_model.dart';
import 'package:templates_flutter_app/services/user_pay_services.dart';

class PaymentController extends ChangeNotifier {
  PaymentOp _paymentMethod = PaymentOp.none;

  PaymentOp get paymentMethod => _paymentMethod;

  void setPaymentMethod(PaymentOp method) {
    _paymentMethod = method;
    notifyListeners();
  }

  void processPayment(BuildContext context, UserPayServices userServices) {
    if (_paymentMethod == PaymentOp.none) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, selecciona un método de pago")),
      );
      return;
    }

    if (_paymentMethod == PaymentOp.paypal) {
      userServices.navigatePaypal(context);
    } else if (_paymentMethod == PaymentOp.stripe) {
      userServices.makePayment(context);
      ///userServices.userPay(context);
    }
  }
}
