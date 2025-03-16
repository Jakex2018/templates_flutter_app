enum PaymentOp { card, paypal }

class PaymentMethodModel {
  final PaymentOp payment;
  final String name; // Optional: Display name for the payment method

  const PaymentMethodModel({required this.payment, required this.name});
}

final List<PaymentMethodModel> paymentMethods = [
  const PaymentMethodModel(
      payment: PaymentOp.card, name: 'Credit/Debit Card'),
  const PaymentMethodModel(payment: PaymentOp.paypal, name: 'PayPal'),
];