import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Method'),
        centerTitle: true,
      ),
      body: const PaymentBody(),
    );
  }
}

class PaymentBody extends StatelessWidget {
  const PaymentBody({super.key});

  @override
  Widget build(BuildContext context) {
    // Implementa la interfaz de usuario para la sección de pago aquí
    return Center(
      child: Container(
        // ... (el resto del código de tu PaymentBody original)
      ),
    );
  }
}

