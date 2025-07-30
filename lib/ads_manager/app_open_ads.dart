import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/cupertino.dart';

class AppOpenAdController extends GetxController with WidgetsBindingObserver {
  final RxBool isShowingOpenAd = false.obs;

  AppOpenAd? _appOpenAd;
  bool _isAdAvailable = false;
  bool shouldShowAppOpenAd = true;
  bool isCooldownActive = false;
  bool _interstitialAdDismissed = false;
  bool _openAppAdEligible = false;
  bool isAppResumed = false;
  bool _isSplashInterstitialShown = false;

  @override
  void onInit() {
    super.onInit();
    loadAd();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      debugPrint("App moved to background.");
      _openAppAdEligible = true;
    } else if (state == AppLifecycleState.resumed) {
      debugPrint("App moved to foreground.");

      Future.delayed(const Duration(milliseconds: 100), () {
        if (_openAppAdEligible && !_interstitialAdDismissed) {
          showAdIfAvailable();
        } else {
          debugPrint("Skipping Open App Ad (flags not met).");
        }
        _openAppAdEligible = false;
        _interstitialAdDismissed = false;
      });
    }
  }

  void showAdIfAvailable() {
    if (_isAdAvailable && _appOpenAd != null && !isCooldownActive) {
      _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          debugPrint('App Open Ad is showing.');
          isShowingOpenAd.value = true;
        },
        onAdDismissedFullScreenContent: (ad) {
          debugPrint('App Open Ad dismissed.');
          _appOpenAd = null;
          _isAdAvailable = false;
          isShowingOpenAd.value = false;
          loadAd();
          activateCooldown();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          debugPrint('Failed to show App Open Ad: $error');
          _appOpenAd = null;
          _isAdAvailable = false;
          isShowingOpenAd.value = false;
          loadAd();
        },
      );

      _appOpenAd!.show();
      _appOpenAd = null;
      _isAdAvailable = false;
    } else {
      debugPrint('No App Open Ad available to show.');
      loadAd();
    }
  }

  void activateCooldown() {
    isCooldownActive = true;
    Future.delayed(const Duration(seconds: 5), () {
      isCooldownActive = false;
    });
  }

  String get appOpenAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/3419835294';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/5662855259';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  void loadAd() {
    if (!shouldShowAppOpenAd) return;
    AppOpenAd.load(
      adUnitId: appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _isAdAvailable = true;
          debugPrint('App Open Ad loaded.');
        },
        onAdFailedToLoad: (error) {
          debugPrint('Failed to load App Open Ad: $error');
          _isAdAvailable = false;
        },
      ),
    );
  }

  void setInterstitialAdDismissed() {
    _interstitialAdDismissed = true;
    debugPrint("Interstitial Ad dismissed, flag set.");
  }

  void setSplashInterstitialFlag(bool shown) {
    _isSplashInterstitialShown = shown;
  }

  void maybeShowAppOpenAd() {
    if (_isSplashInterstitialShown) {
      debugPrint("### Skipping AppOpenAd due to splash interstitial.");
      return;
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _appOpenAd?.dispose();
    super.onClose();
  }
}
