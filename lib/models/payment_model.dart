enum PaymentOp { card, paypal }

class PaymentMethodModel {
  final PaymentOp payment;
  final String name; // Optional: Display name for the payment method

  const PaymentMethodModel({required this.payment, required this.name});

  factory PaymentMethodModel.fromMap(Map<String, dynamic> map) {
    return PaymentMethodModel(
      payment: PaymentOp.values.firstWhere(
        (e) => e.toString() == 'PaymentOp.${map['payment']}',
        orElse: () => PaymentOp.card, // Valor por defecto
      ),
      name: map['name'] ?? '',
    );
  }
  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      payment: PaymentOp.values.firstWhere(
        (e) => e.toString() == 'PaymentOp.${json['payment']}',
        orElse: () => PaymentOp.card, // Valor por defecto
      ),
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'payment':
          payment.toString().split('.').last, // Convierte PaymentOp a String
      'name': name,
    };
  }
}
