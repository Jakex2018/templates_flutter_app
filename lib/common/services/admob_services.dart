
// ignore_for_file: avoid_print
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobServices {
  Future<InitializationStatus> initialization;
  AdmobServices(this.initialization);

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
}