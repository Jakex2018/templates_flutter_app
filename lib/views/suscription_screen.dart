import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/common/constants/constants.dart';
import 'package:templates_flutter_app/controllers/suscription_controller.dart';
import 'package:templates_flutter_app/providers/auth_user_provider.dart';
import 'package:templates_flutter_app/models/suscription_model.dart';
import 'package:templates_flutter_app/providers/suscription_provider.dart';
import 'package:templates_flutter_app/services/suscription_services.dart';
import 'package:templates_flutter_app/widget/button01.dart';

class SuscriptionScreen extends StatefulWidget {
  const SuscriptionScreen({super.key});

  @override
  State<SuscriptionScreen> createState() => _SuscriptionScreenState();
}

class _SuscriptionScreenState extends State<SuscriptionScreen> {
  late final SuscriptionController suscriptionController;
  @override
  void initState() {
    super.initState();
    suscriptionController = SuscriptionController(
      subscriptionServices: SuscriptionServices(),
      suscriptionProvider: SuscriptionProvider(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthUserProvider>(context);
    final userId = authProvider.userId;
   

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a Subscription'),
        centerTitle: true,
      ),
      body: _buildSuscriptionBody(context, userId!),
    );
  }

  Widget _buildSuscriptionBody(BuildContext context, String userId) {
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
        final suscription = infoCard[index];
        return suscriptionCard(context, suscription, index, userId);
      },
      separatorBuilder: (context, index) => const SizedBox(width: 10),
      itemCount: infoCard.length,
    );
  }

  Widget suscriptionCard(BuildContext context, SuscriptionModel suscription,
      int index, String? userId) {
    final isSuscribed = Provider.of<SuscriptionProvider>(context).isSuscribed;

    return Container(
      width: MediaQuery.of(context).size.width * .8,
      padding: const EdgeInsetsDirectional.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            suscriptionCardTop(context, suscription),
            suscriptionCardDetails(suscription),
            const SizedBox(height: 20),
            Text(
              '\$${suscription.price}/Month',
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 3),
            ),
            const SizedBox(height: 30),
            suscriptionCardButton(isSuscribed, suscription, context, userId)
          ],
        ),
      ),
    );
  }

  Widget suscriptionCardButton(bool isSuscribed, SuscriptionModel suscription,
      BuildContext context, String? userId) {
    return ButtonOne(
      text: isSuscribed
          ? suscription.cat == SuscriptionCat.free
              ? 'Default'
              : "Cancel"
          : suscription.cat == SuscriptionCat.free
              ? 'Default'
              : "Buy",
      onPressed: () {
        isSuscribed
            ? suscriptionController.cancelSubscription(
                context, userId, suscription)
            : suscriptionController.handleSubscription(
                context,
                suscription,
              );
      },
      backgroundColor: !isSuscribed || suscription.cat == SuscriptionCat.free
          ? kpurpleColor
          : Colors.red.withOpacity(0.5),
    );
  }

  Widget suscriptionCardDetails(SuscriptionModel suscription) {
    return Column(
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
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget suscriptionCardTop(
      BuildContext context, SuscriptionModel suscription) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      height: 170,
      width: MediaQuery.of(context).size.width * .7,
      decoration: BoxDecoration(
        color: kpurpleColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          suscription.icon,
          SizedBox(
            width: 10,
          ),
          Text(
            suscription.title,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40),
          ),
        ],
      ),
    );
  }
}




/*
class SuscriptionScreen extends StatelessWidget {
  const SuscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a Subscription'),
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final suscriptionServices = SuscriptionServices();
    final suscriptionProvider = Provider.of<SuscriptionProvider>(context);
    suscriptionController = SuscriptionController(
      subscriptionServices: suscriptionServices,
      suscriptionProvider: suscriptionProvider,
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
        child: listViewSuscriptions(userId),
      ),
    );
  }

  Widget listViewSuscriptions(String? userId) {
    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final suscription = infoCard[index];
        return listViewContent(context, suscription, index, userId);
      },
      separatorBuilder: (context, index) => const SizedBox(width: 10),
      itemCount: infoCard.length,
    );
  }

  Widget listViewContent(BuildContext context, SuscriptionModel suscription,
      int index, String? userId) {
    final isSuscribed = Provider.of<SuscriptionProvider>(context).isSuscribed;

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
          // Contenido de la tarjeta de suscripción
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 170,
            width: MediaQuery.of(context).size.width * .7,
            decoration: BoxDecoration(
              color: kpurpleColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                suscription.icon,
                SizedBox(
                  width: 10,
                ),
                Text(
                  suscription.title,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 40),
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
                            style: TextStyle(fontSize: 14, color: Colors.black),
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
            '\$${suscription.price}/Month',
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 3),
          ),
          const SizedBox(height: 30),
          isSuscribed
              ? ButtonOne(
                  text: isSuscribed
                      ? suscription.cat == SuscriptionCat.free
                          ? 'Default'
                          : "Cancel"
                      : suscription.cat == SuscriptionCat.free
                          ? 'Default'
                          : "Buy",
                  onPressed: () => suscriptionController.cancelSubscription(
                      context, userId, suscription),
                  backgroundColor: suscription.cat == SuscriptionCat.free
                      ? kpurpleColor
                      : Colors.red.withOpacity(0.5),
                )
              : ButtonOne(
                  text: suscription.cat == SuscriptionCat.free
                      ? 'Default'
                      : "Buy",
                  onPressed: () => suscriptionController.handleSubscription(
                      context, suscription),
                  backgroundColor: kpurpleColor,
                ),
        ],
      ),
    );
  }
}

 */