import 'dart:io';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../presentation/remove_ads_contrl/remove_ads_contrl.dart';

class AppOpenAdController extends GetxController with WidgetsBindingObserver {
  final RxBool isShowingOpenAd = false.obs;
  final RemoveAds removeAdsController = Get.put(RemoveAds());

  AppOpenAd? _appOpenAd;
  bool _isAdAvailable = false;
  bool shouldShowAppOpenAd = true;
  bool isCooldownActive = false;
  bool _interstitialAdDismissed = false;
  bool _openAppAdEligible = false;
  bool isAppResumed = false;
  bool _isSplashInterstitialShown = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _openAppAdEligible = true;
    } else if (state == AppLifecycleState.resumed) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_openAppAdEligible && !_interstitialAdDismissed) {
          showAdIfAvailable();
        } else {
          print("Skipping Open App Ad (flags not met).");
        }
        _openAppAdEligible = false;
        _interstitialAdDismissed = false;
      });
    }
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    initializeRemoteConfig();
  }

  Future<void> initializeRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    try {
      await remoteConfig.fetchAndActivate();
      String remoteConfigKey;
      if (Platform.isAndroid) {
        remoteConfigKey = 'AppOpenAd';
      } else if (Platform.isIOS) {
        remoteConfigKey = 'AppOpenAd';
      } else {
        throw UnsupportedError('Unsupported platform');
      }
      shouldShowAppOpenAd = remoteConfig.getBool(remoteConfigKey);
      loadAd();
    } catch (e) {
      print('Error fetching Remote Config: $e');
    }
  }

  void showAdIfAvailable() {
    // if (Platform.isIOS && removeAdsController.isSubscribedGet.value) {
    //   return;
    // }
    if (_isAdAvailable && _appOpenAd != null && !isCooldownActive) {
      _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          isShowingOpenAd.value = true;
        },
        onAdDismissedFullScreenContent: (ad) {
          _appOpenAd = null;
          _isAdAvailable = false;
          isShowingOpenAd.value = false;
          loadAd();
          activateCooldown();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
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
      return 'ca-app-pub-8172082069591999/9868242342';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5405847310750111/9398303204';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  void loadAd() {
    if (Platform.isIOS && removeAdsController.isSubscribedGet.value) {
      return;
    }
    if (!shouldShowAppOpenAd) return;
    AppOpenAd.load(
      adUnitId: appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _isAdAvailable = true;
        },
        onAdFailedToLoad: (error) {
          _isAdAvailable = false;
        },
      ),
    );
  }

  void setInterstitialAdDismissed() {
    _interstitialAdDismissed = true;
  }

  void setSplashInterstitialFlag(bool shown) {
    _isSplashInterstitialShown = shown;
  }

  void maybeShowAppOpenAd() {
    if (_isSplashInterstitialShown) {
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

// class AppOpenAdManager extends GetxController with WidgetsBindingObserver {
//   final RxBool isAdVisible = false.obs;
//
//   AppOpenAd? _currentAd;
//   bool _canDisplayAd = false;
//   bool _resumeEligible = false;
//
//   @override
//   void onInit() {
//     super.onInit();
//     WidgetsBinding.instance.addObserver(this);
//     initRemoteConfig();
//   }
//
//   @override
//   void onClose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _currentAd?.dispose();
//     super.onClose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.paused) {
//       _resumeEligible = true;
//     } else if (state == AppLifecycleState.resumed) {
//       Future.delayed(const Duration(milliseconds: 80), () {
//         if (_resumeEligible) {
//           _displayAdIfAvailable();
//         }
//         _resumeEligible = false;
//       });
//     }
//   }
//
//   Future<void> initRemoteConfig() async {
//     try {
//       await RemoteConfigService().init();
//       final showAd = RemoteConfigService().getBool('AppOpenAd');
//       if (showAd) {
//         _loadAppOpenAd();
//       }
//     } catch (e) {
//       debugPrint("Failed to initialize remote config: $e");
//     }
//   }
//
//   void _displayAdIfAvailable() {
//     if (_canDisplayAd && _currentAd != null) {
//       _currentAd!.fullScreenContentCallback = FullScreenContentCallback(
//         onAdShowedFullScreenContent: (_) {
//           isAdVisible.value = true;
//         },
//         onAdDismissedFullScreenContent: (_) {
//           _resetAd();
//         },
//         onAdFailedToShowFullScreenContent: (_, error) {
//           debugPrint("AppOpenAd error: $error");
//           _resetAd();
//         },
//       );
//       _currentAd!.show();
//       _resetAd();
//     } else {
//       debugPrint("AppOpenAd not ready or blocked.");
//       _loadAppOpenAd();
//     }
//   }
//
//   void _resetAd() {
//     _currentAd = null;
//     _canDisplayAd = false;
//     isAdVisible.value = false;
//   }
//
//   void _loadAppOpenAd() {
//     AppOpenAd.load(
//       adUnitId: _getAdUnitId(),
//       request: const AdRequest(),
//       adLoadCallback: AppOpenAdLoadCallback(
//         onAdLoaded: (ad) {
//           _currentAd = ad;
//           _canDisplayAd = true;
//         },
//         onAdFailedToLoad: (error) {
//           debugPrint("Failed to load AppOpenAd: $error");
//           _canDisplayAd = false;
//         },
//       ),
//     );
//   }
//
//   String _getAdUnitId() {
//     if (Platform.isAndroid) {
//       return 'ca-app-pub-8172082069591999/9868242342';
//     } else if (Platform.isIOS) {
//       return '';
//     } else {
//       throw UnsupportedError('Platform not supported');
//     }
//   }
//
//
//   void setInterstitialAdDismissed() {
//     _interstitialAdDismissed = true;
//   }
//
//   void setSplashInterstitialFlag(bool shown) {
//     _isSplashInterstitialShown = shown;
//   }
// }
