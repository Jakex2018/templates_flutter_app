// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:templates_flutter_app/providers/payment_provider.dart';
import 'package:templates_flutter_app/services/user_pay_services.dart';
import 'package:templates_flutter_app/models/suscription_model.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key, required this.suscription});
  final SuscriptionModel suscription;

  @override
  Widget build(BuildContext context) {
    final UserPayServices userServices = UserPayServices.instance;
    final paymentProvider = Provider.of<PaymentMethodProvider>(context);

    return Scaffold(
      appBar: _buildApp(),
      body: _buildBody(paymentProvider, userServices, context),
    );
  }

  Padding _buildBody(PaymentMethodProvider paymentProvider,
      UserPayServices userServices, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Resumen del Pago",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text("Producto: Suscripción Premium"),
                  Text("Total: \$5.00"),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Selecciona un Método de Pago",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text("Pagar con PayPal"),
            tileColor: paymentProvider.paymentMethod == PaymentOp.paypal
                ? Colors.blue.withOpacity(0.2)
                : null,
            onTap: () {
              paymentProvider.setPaymentMethod(PaymentOp.paypal);
            },
          ),
          ListTile(
            leading: Icon(Icons.credit_card),
            title: Text("Pagar con Stripe"),
            tileColor: paymentProvider.paymentMethod == PaymentOp.stripe
                ? Colors.blue.withOpacity(0.2)
                : null,
            onTap: () {
              paymentProvider.setPaymentMethod(PaymentOp.stripe);
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (paymentProvider.paymentMethod == PaymentOp.paypal) {
                userServices.navigatePaypal(context);
              } else if (paymentProvider.paymentMethod == PaymentOp.stripe) {
                userServices.makePayment(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text("Por favor, selecciona un método de pago")),
                );
              }
            },
            child: Text("Confirmar Pago"),
          ),
        ],
      ),
    );
  }

  AppBar _buildApp() {
    return AppBar(
      title: Text("Eligir Método de Pago"),
    );
  }
}
