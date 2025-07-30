import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdController extends GetxController {
  InterstitialAd? _interstitialAd;
  bool isAdReady = false;
  int screenVisitCount = 0;
  int adTriggerCount = 3;

  @override
  void onInit() {
    super.onInit();
    loadInterstitialAd();
  }

  String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          isAdReady = true;
          update();
        },
        onAdFailedToLoad: (error) {
          debugPrint("Interstitial Ad failed to load: $error");
          isAdReady = false;
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          debugPrint("### Ad Dismissed, resetting visit count.");
          screenVisitCount = 0;
          ad.dispose();
          isAdReady = false;
          loadInterstitialAd();
          update();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          debugPrint("### Ad failed to show: $error");
          screenVisitCount = 0;
          ad.dispose();
          isAdReady = false;
          loadInterstitialAd();
          update();
        },
      );

      debugPrint("### Showing Interstitial Ad.");
      _interstitialAd!.show();
      _interstitialAd = null;
    } else {
      debugPrint("### Interstitial Ad not ready.");
    }
  }

  void checkAndShowAd() {
    screenVisitCount++;
    debugPrint("############## Screen Visit Count: $screenVisitCount");

    if (screenVisitCount >= adTriggerCount) {
      debugPrint("### OK");
      if (isAdReady) {
        showInterstitialAd();
      } else {
        debugPrint("### Interstitial Ad not ready yet.");
        screenVisitCount = 0;
      }
    }
  }

  @override
  void onClose() {
    _interstitialAd?.dispose();
    super.onClose();
  }
}
