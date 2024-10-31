// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/constants.dart';
import 'package:templates_flutter_app/screens/payment/widget/payment_credit_content.dart';
import 'package:templates_flutter_app/screens/suscription/model/payment_model.dart';
import 'package:templates_flutter_app/screens/suscription/model/suscription_model.dart';

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
  final PaymentMethod paymentMethod;
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
