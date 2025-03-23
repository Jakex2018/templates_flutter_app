// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/controllers/payment_controller.dart';
import 'package:templates_flutter_app/models/payment_model.dart';
import 'package:templates_flutter_app/models/suscription_model.dart';
import 'package:templates_flutter_app/services/user_pay_services.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key, required this.suscription});
  final SuscriptionModel suscription;

  @override
  Widget build(BuildContext context) {
    final userServices = UserPayServices.instance;
    final paymentController = Provider.of<PaymentController>(context);

    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(paymentController, userServices, context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text("Elegir Método de Pago"),
    );
  }

  Widget _buildBody(PaymentController paymentController,
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
            tileColor: paymentController.paymentMethod == PaymentOp.paypal
                ? Colors.blue.withOpacity(0.2)
                : null,
            onTap: () {
              paymentController.setPaymentMethod(PaymentOp.paypal);
            },
          ),
          ListTile(
            leading: Icon(Icons.credit_card),
            title: Text("Pagar con Stripe"),
            tileColor: paymentController.paymentMethod == PaymentOp.stripe
                ? Colors.blue.withOpacity(0.2)
                : null,
            onTap: () {
              paymentController.setPaymentMethod(PaymentOp.stripe);
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              paymentController.processPayment(context, userServices);
            },
            child: Text("Confirmar Pago"),
          ),
        ],
      ),
    );
  }
}
