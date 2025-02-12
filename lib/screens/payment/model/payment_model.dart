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