import 'dart:io';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import 'app_open_ads.dart';

class SplashInterstitialAdController extends GetxController {
  InterstitialAd? _interstitialAd;
  bool isAdReady = false;
  bool showSplashAd = true;
  // final RemoveAds removeAdsController = Get.put(RemoveAds());

  @override
  void onInit() {
    super.onInit();
    initializeRemoteConfig();
    loadInterstitialAd();
    showInterstitialAdUser();
  }

  Future<void> initializeRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    try {
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(seconds: 1),
        ),
      );
      String interstitialKey;
      if (Platform.isAndroid) {
        interstitialKey = 'SplashInterstitial';
      } else if (Platform.isIOS) {
        interstitialKey = 'SplashInterstitial';
      } else {
        throw UnsupportedError('Unsupported platform');
      }
      await remoteConfig.fetchAndActivate();
      showSplashAd = remoteConfig.getBool(interstitialKey);
      update();
    } catch (e) {
      print('Error fetching Remote Config: $e');
      showSplashAd = false;
    }
  }

  String get spInterstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-8172082069591999/9899229608';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5405847310750111/4798946165';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: spInterstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          isAdReady = true;
          update();
        },
        onAdFailedToLoad: (error) {
          print("Interstitial Ad failed to load: $error");
          isAdReady = false;
        },
      ),
    );
  }

  Future<void> showInterstitialAd() async {
    // if (Platform.isIOS && removeAdsController.isSubscribedGet.value) {
    //   return;
    // }
    if (!showSplashAd) {
      return;
    }
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          Get.find<AppOpenAdController>().setInterstitialAdDismissed();
          ad.dispose();
          isAdReady = false;
          loadInterstitialAd();
          update();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print("### Ad failed to show: $error");
          ad.dispose();
          isAdReady = false;
          loadInterstitialAd();
          update();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    } else {
      print("### Interstitial Ad not ready.");
    }
  }

  Future<void> showInterstitialAdUser({VoidCallback? onAdComplete}) async {
    if (!showSplashAd || _interstitialAd == null) {
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) async {
        Get.find<AppOpenAdController>().setInterstitialAdDismissed();
        ad.dispose();
        isAdReady = false;
        loadInterstitialAd();
        onAdComplete?.call();
        update();
        // await Future.delayed(Duration(milliseconds: 500));
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        isAdReady = false;
        loadInterstitialAd();
        onAdComplete?.call();
        update();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  @override
  void onClose() {
    _interstitialAd?.dispose();
    super.onClose();
  }
}
