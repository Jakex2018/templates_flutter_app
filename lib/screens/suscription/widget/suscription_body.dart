import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/constants.dart';
import 'package:templates_flutter_app/screens/home/home_app.dart';
import 'package:templates_flutter_app/screens/payment/payment_screen.dart';
import 'package:templates_flutter_app/screens/suscription/model/suscription_model.dart';
import 'package:templates_flutter_app/screens/suscription/model/user_model.dart';
import 'package:templates_flutter_app/widget/button01.dart';

class SuscriptionBody extends StatelessWidget {
  const SuscriptionBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthUserProvider>(context);
    final userId = authProvider.userId;
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: MediaQuery.of(context).size.height * .75,
        width: MediaQuery.of(context).size.width * .9,
        child: listViewSuscriptions(userId),
      ),
    );
  }

  Widget listViewSuscriptions(String? userId) {
    return ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final subscriptionProvider =
              Provider.of<SuscriptionProvider>(context, listen: false);
          final suscription = infoCard[index];
          return listViewContent(
              context, suscription, subscriptionProvider, index, userId);
        },
        separatorBuilder: (context, index) => const SizedBox(
              width: 10,
            ),
        itemCount: infoCard.length);
  }

  Widget listViewContent(BuildContext context, SuscriptionModel suscription,
      SuscriptionProvider subscriptionProvider, int index, String? userId) {
    return Container(
      width: MediaQuery.of(context).size.width * .8,
      padding: const EdgeInsetsDirectional.symmetric(vertical: 20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(30)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 170.h,
            width: MediaQuery.of(context).size.width * .7,
            decoration: BoxDecoration(
              color: kpurpleColor,
              borderRadius: BorderRadius.circular(20.sp),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                suscription.icon,
                Text(suscription.title,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.sp)),
              ],
            ),
          ),
          Column(children: [
            for (int i = 0; i < suscription.items.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Container(
                  margin: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        suscription.items['items0${i + 1}']!,
                        height: 65,
                      ),
                      SizedBox(
                        width: 100,
                        child: Text(
                          suscription.desc['desc0${i + 1}']!,
                          style:
                              TextStyle(fontSize: 14.sp, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ]),
          const SizedBox(
            height: 43,
          ),
          subscriptionProvider.isSuscribed
              ? ButtonOne(
                  text: subscriptionProvider.isSuscribed
                      ? infoCard[index].cat == SuscriptionCat.free
                          ? 'Default'
                          : "Cancel"
                      : infoCard[index].cat == SuscriptionCat.free
                          ? 'Default'
                          : "Buy",
                  onPressed: () => handleCancelSuscription(
                      context, suscription, subscriptionProvider, userId),
                  backgroundColor: infoCard[index].cat == SuscriptionCat.free
                      ? kpurpleColor
                      : Colors.red.withOpacity(.5),
                )
              : ButtonOne(
                  text: infoCard[index].cat == SuscriptionCat.free
                      ? 'Default'
                      : "Buy",
                  onPressed: () {
                    handleSuscription(context, suscription);
                  },
                  backgroundColor: kpurpleColor,
                )
        ],
      ),
    );
  }

  void handleSuscription(
    BuildContext context,
    SuscriptionModel suscription,
  ) {
    suscription.cat == SuscriptionCat.premium
        ? Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PaymentScreen(),
            ))
        : showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('You have Default Free Account'),
              actions: [
                MaterialButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
              ],
            ),
          );
  }

  handleCancelSuscription(BuildContext context, SuscriptionModel suscription,
      SuscriptionProvider subscriptionProvider, String? userId) {
    suscription.cat == SuscriptionCat.premium
        ? subscriptionProvider.isSuscribed
            ? dialogCancelSuscription(context, userId, subscriptionProvider)
            : Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaymentScreen(),
                ))
        : dialogMemberSuscription(context);
  }

  Future<dynamic> dialogMemberSuscription(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('You have a Member Suscription'),
        actions: [
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  Future<dynamic> dialogCancelSuscription(BuildContext context, String? userId,
      SuscriptionProvider subscriptionProvider) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure you want cancel Suscription?'),
        actions: [
          MaterialButton(
              onPressed: () async {
                if (userId != null) {
                  subscriptionProvider.cancelSuscription(
                      userId, subscriptionProvider.suscriptionEndDate);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 3),
                      margin: EdgeInsets.only(bottom: 50, left: 60, right: 50),
                      content: Text('Subscription canceled successfully.'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 3),
                      margin: EdgeInsets.only(bottom: 50, left: 60, right: 50),
                      content: Text(
                          'Failed to cancel subscription: User ID is null.'),
                    ),
                  );
                }

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Home(),
                    ));
              },
              child: const Text("Ok")),
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }
}
