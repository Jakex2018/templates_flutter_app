import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  /*
  Future<InitializationStatus> initialization;
  AdService(this.initialization);
   */
  RewardedAd? rewardedAd;

  String? get bannerAdUid {
    if (kReleaseMode) {
      if (Platform.isAndroid) {
        return "ca-app-pub-5699804099110465~1293005254";
      }
    } else {
      if (Platform.isAndroid) {
        return "ca-app-pub-3940256099942544/9214589741";
      }
    }
    return null;
  }

  String? get interstitialAdUid {
    if (kReleaseMode) {
      if (Platform.isAndroid) {
        return "ca-app-pub-5699804099110465/2925660861";
      }
    } else {
      if (Platform.isAndroid) {
        return "ca-app-pub-5699804099110465/2925660861";
      }
    }
    return null;
  }

  String? get rewardsAdUid {
    if (kReleaseMode) {
      if (Platform.isAndroid) {
        return "ca-app-pub-5699804099110465~1293005254";
      } else {
        return null;
      }
    } else {
      if (Platform.isAndroid) {
        return "ca-app-pub-3940256099942544/5224354917";
      } else {
        return null;
      }
    }
  }

  final BannerAdListener bannerListener = BannerAdListener(
      onAdOpened: (Ad ad) => print('AD OPENED'),
      onAdClosed: (Ad ad) => print('AD CLOSED'),
      onAdLoaded: (Ad ad) => print('AD LOADED'),
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        ad.dispose();
        print('AD FAILED TO LOAD: $error');
      });

  Future<void> loadRewardedAd(String adUnitId) async {
    await RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          rewardedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          rewardedAd = null;
        },
      ),
    );
  }

  Future<void> showRewardedAd() async {
    if (rewardedAd != null) {
      rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          ad.dispose();
          loadRewardedAd(rewardsAdUid!);
        },
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
          ad.dispose();
          loadRewardedAd(rewardsAdUid!);
        },
      );
      await rewardedAd!.show(
        onUserEarnedReward: (ad, reward) => ad.dispose(),
      );
    }
  }

  Future<RewardedAd?> _createRewardAd() async {
    RewardedAd? rewardedAd;
    await RewardedAd.load(
      adUnitId: rewardsAdUid!,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          rewardedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          rewardedAd = null;
        },
      ),
    );
    return rewardedAd;
  }
}
