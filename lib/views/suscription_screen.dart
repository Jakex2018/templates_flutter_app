import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/common/constants/constants.dart';
import 'package:templates_flutter_app/controllers/suscription_controller.dart';
import 'package:templates_flutter_app/providers/auth_user_provider.dart';
import 'package:templates_flutter_app/models/suscription_model.dart';
import 'package:templates_flutter_app/providers/suscription_provider.dart';
import 'package:templates_flutter_app/services/suscription_services.dart';
import 'package:templates_flutter_app/widget/button01.dart';

class SuscriptionScreen extends StatelessWidget {
  const SuscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a Suscription'),
        centerTitle: true,
      ),
      body: const SuscriptionBody(),
    );
  }
}

class SuscriptionBody extends StatefulWidget {
  const SuscriptionBody({super.key});

  @override
  State<SuscriptionBody> createState() => _SuscriptionBodyState();
}

class _SuscriptionBodyState extends State<SuscriptionBody> {
  late SuscriptionController suscriptionController;
  late SuscriptionProvider suscriptionProvider;
  late SuscriptionServices suscriptionServices;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    suscriptionProvider = Provider.of<SuscriptionProvider>(context);
    suscriptionServices = SuscriptionServices();
    suscriptionController = SuscriptionController(
      subscriptionProvider: suscriptionProvider,
      subscriptionServices: suscriptionServices,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthUserProvider>(context);
    final userId = authProvider.userId;

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: MediaQuery.of(context).size.height * .75,
        width: MediaQuery.of(context).size.width * .9,
        child: listViewSuscriptions(userId, suscriptionController),
      ),
    );
  }

  Widget listViewSuscriptions(
      String? userId, SuscriptionController controller) {
    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final suscription = infoCard[index];
        return listViewContent(context, suscription, controller, index, userId);
      },
      separatorBuilder: (context, index) => const SizedBox(width: 10),
      itemCount: infoCard.length,
    );
  }

  Widget listViewContent(BuildContext context, SuscriptionModel suscription,
      SuscriptionController controller, int index, String? userId) {
    return Container(
      width: MediaQuery.of(context).size.width * .8,
      padding: const EdgeInsetsDirectional.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
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
                Text(
                  suscription.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.sp,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              for (int i = 0; i < suscription.items.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          suscription.items['items0${i + 1}']!,
                          height: 60,
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
            ],
          ),
          const SizedBox(height: 20),
          Text(
            suscription.price != null ? '\$${suscription.price}/Month' : '',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 30),
          controller.isSuscribed
              ? ButtonOne(
                  text: controller.isSuscribed
                      ? suscription.cat == SuscriptionCat.free
                          ? 'Default'
                          : "Cancel"
                      : suscription.cat == SuscriptionCat.free
                          ? 'Default'
                          : "Buy",
                  onPressed: () => controller.cancelSubscription(
                      context, userId, suscription),
                  backgroundColor: suscription.cat == SuscriptionCat.free
                      ? kpurpleColor
                      : Colors.red.withOpacity(0.5),
                )
              : ButtonOne(
                  text: suscription.cat == SuscriptionCat.free
                      ? 'Default'
                      : "Buy",
                  onPressed: () =>
                      controller.handleSubscription(context, suscription),
                  backgroundColor: kpurpleColor,
                ),
        ],
      ),
    );
  }
}
