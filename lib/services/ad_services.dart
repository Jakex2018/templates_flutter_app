import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  RewardedAd? _rewardedAd;
  bool _isAdLoaded = false;

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    await _loadRewardedAd('$bannerAdUid');
  }

  Future<void> _loadRewardedAd(String rewardedAdUid) async {
    try {
      await RewardedAd.load(
        adUnitId: rewardsAdUid!,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            _rewardedAd = ad;
            _isAdLoaded = true;
            _setAdListeners();
          },
          onAdFailedToLoad: (LoadAdError error) {
            _isAdLoaded = false;
            _rewardedAd = null;
          },
        ),
      );
    } catch (e) {
      return;
    }
  }

  void _setAdListeners() {
    _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        ad.dispose();
        _loadRewardedAd('$bannerAdUid');
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        ad.dispose();
        _loadRewardedAd('$bannerAdUid');
      },
    );
  }

  Future<bool> showRewardedAd() async {
    if (!_isAdLoaded) {
      await _loadRewardedAd('$bannerAdUid');
    }

    if (_rewardedAd != null) {
      try {
        await _rewardedAd!.show(
          onUserEarnedReward: (ad, reward) {
            ad.dispose();
            _loadRewardedAd('$bannerAdUid');
          },
        );
        return true;
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  // ... (mantén tus otros métodos existentes)
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
        return "ca-app-pub-5699804099110465~1293005254";
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
        return "ca-app-pub-5699804099110465/1272262873";
      } else {
        return null;
      }
    }
  }

  /*ca-app-pub-3940256099942544/5224354917*/

  final BannerAdListener bannerListener = BannerAdListener(
      onAdOpened: (Ad ad) => {},
      onAdClosed: (Ad ad) => {},
      onAdLoaded: (Ad ad) => {},
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        ad.dispose();
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

  /*
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
   */
}
