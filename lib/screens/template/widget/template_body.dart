// ignore_for_file: avoid_print
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/common/services/admob_services.dart';
import 'package:templates_flutter_app/screens/suscription/provider/suscription_provider.dart';
import 'package:templates_flutter_app/screens/template/widget/template_option.dart';
import 'package:templates_flutter_app/screens/template/widget/template_web_app.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TemplateBody extends StatefulWidget {
  const TemplateBody(
      {super.key,
      required this.image,
      required this.title,
      required this.url,
      required this.nameImg,
      required this.fetchDownloadImage,
      required this.fetchSaveUrlTemplate,
      required this.accessDemo});
  final String image;
  final String title;
  final String url;
  final String nameImg;
  final Function(String) fetchDownloadImage;
  final Function(String) fetchSaveUrlTemplate;
  final Future<WebApp?> accessDemo;

  @override
  State<TemplateBody> createState() => _TemplateBodyState();
}

class _TemplateBodyState extends State<TemplateBody> {
  late AdmobServices _admobServices;

  RewardedAd? rewardedAd;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _admobServices = context.read<AdmobServices>();
    _createRewardAd();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [_templateName(context), _templateImage(context)],
    );
  }

  Container _templateImage(BuildContext context) {
    final subscriptionProvider =
        Provider.of<SuscriptionProvider>(context, listen: false);
    return Container(
      height: 560.h,
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).colorScheme.secondary,
      child: SingleChildScrollView(
        child: Column(
          children: [
            CachedNetworkImage(
              placeholder: (context, url) => ClipRRect(
                  borderRadius: BorderRadius.circular(20.sp),
                  child: Image.asset('asset/bg_01.jpg')),
              imageUrl: widget.image,
              fit: BoxFit.fitHeight,
              height: 250.h,
            ),
            SizedBox(
              height: 50.h,
            ),
            TemplateOption(
              title: 'Download Image',
              onTap: () async {
                if (!subscriptionProvider.isSuscribed) {
                  await _showRewardAd();
                }
                await widget.fetchDownloadImage(widget.image);
              },
              icon: Icon(
                Icons.download_for_offline_rounded,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 40,
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            TemplateOption(
                title: 'Source Code',
                icon: Icon(
                  Icons.code,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  size: 40,
                ),
                onTap: () async {
                  if (!subscriptionProvider.isSuscribed) {
                    await _showRewardAd();
                  }
                  await widget.fetchSaveUrlTemplate(widget.url);
                }),
            SizedBox(
              height: 30.h,
            ),
            TemplateOption(
              title: 'Demo',
              icon: Icon(
                Icons.developer_mode,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 40,
              ),
              onTap: () async {
                if (!subscriptionProvider.isSuscribed) {
                  await _showRewardAd();
                }
                await Navigator.push(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(
                      builder: (context) => FutureBuilder(
                          future: widget.accessDemo,
                          builder: ((context, snapshot) {
                            if (snapshot.hasData) {
                              return snapshot.data!;
                            } else if (snapshot.hasError) {
                              return Text("Error ${snapshot.error}");
                            } else {
                              return const CircularProgressIndicator();
                            }
                          })),
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }

  Container _templateName(BuildContext context) {
    return Container(
      height: 53.h,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onTertiary,
      ),
      child: Center(
          child: Text(
        widget.title,
        style: TextStyle(
            color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.bold),
      )),
    );
  }

  void _createRewardAd() {
    RewardedAd.load(
        adUnitId: _admobServices.rewardsAdUid!,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            setState(() {
              rewardedAd = ad;
            });
          },
          onAdFailedToLoad: (LoadAdError error) {
            setState(() {
              rewardedAd = null;
            });
          },
        ));
    // ignore: no_leading_underscores_for_local_identifiers
  }

  Future<void> _showRewardAd() async {
    if (rewardedAd != null) {
      rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          ad.dispose();
          _createRewardAd();
        },
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
          ad.dispose();
          _createRewardAd();
        },
      );
    }
    try {
      await rewardedAd!.show(
        onUserEarnedReward: (ad, reward) => ad.dispose,
      );
    } catch (e) {
      print('error $e');
    }
  }
}
