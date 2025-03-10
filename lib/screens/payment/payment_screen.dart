// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:templates_flutter_app/screens/payment/provider/payment_provider.dart';
import 'package:templates_flutter_app/screens/payment/services/user_pay_services.dart';
import 'package:templates_flutter_app/screens/suscription/model/suscription_model.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key, required this.suscription});
  final SuscriptionModel suscription;

  @override
  Widget build(BuildContext context) {
    final UserPayServices userServices = UserPayServices.instance;
    final paymentProvider = Provider.of<PaymentMethodProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Eligir Método de Pago"),
      ),
      body: Padding(
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
                        content:
                            Text("Por favor, selecciona un método de pago")),
                  );
                }
              },
              child: Text("Confirmar Pago"),
            ),
          ],
        ),
      ),
    );
  }
}




/*
class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key, required this.suscription});
  final SuscriptionModel suscription;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Payment Method'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.height * .85,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: kpurpleColor, width: 10),
                  borderRadius: BorderRadius.circular(20.sp),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 5.sp,
                        offset: Offset(0, 5.sp),
                        color: Colors.black,
                        spreadRadius: 2.sp)
                  ]),
              child: PaymentCreditContent(
                suscription: suscription,
              ),
            ),
          ),
        ));
  }
}

class PaymentCreditOption extends StatefulWidget {
  const PaymentCreditOption({
    super.key,
    required this.paymentMethod,
    required this.selected,
  });
  final PaymentOp paymentMethod;
  final bool selected;

  @override
  State<PaymentCreditOption> createState() => _PaymentCreditOptionState();
}

class _PaymentCreditOptionState extends State<PaymentCreditOption> {
  @override
  Widget build(BuildContext context) {
    final activeProvider = Provider.of<PaymentMethodProvider>(context);
    final paymentModel = Provider.of<Paymentmodel>(context);

    return GestureDetector(
      onTap: () {
        activeProvider.setPaymentMethod(widget.paymentMethod);
        paymentModel.setActive(widget.paymentMethod);
      },
      child: Container(
          height: 20.h,
          width: 20.w,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50.sp)),
              color: Colors.white,
              border: Border.all(width: 2.w, color: Colors.black12)),
          child: paymentModel.activePaymentMethod == widget.paymentMethod
              ? Center(
                  child: Container(
                    height: 10.h,
                    width: 10.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50.sp)),
                      color: kpurpleColor,
                    ),
                  ),
                )
              : Container()),
    );
  }
}

 */