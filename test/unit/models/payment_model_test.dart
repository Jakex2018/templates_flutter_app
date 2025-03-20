import 'package:flutter_test/flutter_test.dart';
import 'package:templates_flutter_app/models/payment_model.dart';


void main() {
  test('PaymentMethodModel fromJson should return a valid model', () {
    final json = {'payment': 'paypal', 'name': 'PayPal'}; // Usa 'paypal' como String
    final payment = PaymentMethodModel.fromJson(json);

    expect(payment.name, 'PayPal');
    expect(payment.payment, PaymentOp.paypal);
  });
}