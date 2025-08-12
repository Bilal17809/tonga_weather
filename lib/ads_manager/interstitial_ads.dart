import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../presentation/remove_ads_contrl/remove_ads_contrl.dart';
import '/core/services/services.dart';

class InterstitialAdManager extends GetxController {
  InterstitialAd? _currentAd;
  bool _isAdReady = false;
  var isShow = false.obs;
  int visitCounter = 0;
  late int displayThreshold;
  final RemoveAds removeAdsController = Get.put(RemoveAds());


  @override
  void onInit() {
    super.onInit();
    displayThreshold = 3;
    initRemoteConfig();
    _loadAd();
  }

  @override
  void onClose() {
    _currentAd?.dispose();
    super.onClose();
  }

  String get _adUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-8172082069591999/3525392945';
    } else if (Platform.isIOS) {
      return '';
    } else {
      throw UnsupportedError("Platform not supported");
    }
  }

  Future<void> initRemoteConfig() async {
    try {
      await RemoteConfigService().init(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(seconds: 1),
      );
      final newThreshold = RemoteConfigService().getInt(
        'InterstitialAd',
        'InterstitialAd',
      );
      if (newThreshold > 0) {
        displayThreshold = newThreshold;
      }
    } catch (e) {
      debugPrint("Failed to load Interstitial RemoteConfig: $e");
    }
  }

  void _loadAd() {
    InterstitialAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _currentAd = ad;
          _isAdReady = true;
          update();
        },
        onAdFailedToLoad: (error) {
          _isAdReady = false;
          debugPrint("Interstitial load error: $error");
        },
      ),
    );
  }

  void _showAd() {
    if (_currentAd == null) return;
    isShow.value = true;
    _currentAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        isShow.value = false;
        _resetAfterAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint("Interstitial failed: $error");
        ad.dispose();
        isShow.value = false;
        _resetAfterAd();
      },
    );

    _currentAd!.show();
    _currentAd = null;
    _isAdReady = false;
  }

  void checkAndDisplayAd() {
    if (Platform.isIOS && removeAdsController.isSubscribedGet.value) {
      return;
    }
    visitCounter++;
    debugPrint("Visit count: $visitCounter");
    if (visitCounter >= displayThreshold) {
      if (_isAdReady) {
        _showAd();
      } else {
        debugPrint("Interstitial not ready yet.");
        visitCounter = 0;
      }
    }
  }

  void _resetAfterAd() {
    visitCounter = 0;
    _isAdReady = false;
    _loadAd();
    update();
  }
}
