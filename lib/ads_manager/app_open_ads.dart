import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '/core/services/services.dart';

class AppOpenAdManager extends GetxController with WidgetsBindingObserver {
  final RxBool isAdVisible = false.obs;

  AppOpenAd? _currentAd;
  bool _canDisplayAd = false;
  bool _resumeEligible = false;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    initRemoteConfig();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _currentAd?.dispose();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _resumeEligible = true;
    } else if (state == AppLifecycleState.resumed) {
      Future.delayed(const Duration(milliseconds: 80), () {
        if (_resumeEligible) {
          _displayAdIfAvailable();
        }
        _resumeEligible = false;
      });
    }
  }

  Future<void> initRemoteConfig() async {
    try {
      await RemoteConfigService().init();
      final showAd = RemoteConfigService().getBool('AppOpenAd');
      if (showAd) {
        _loadAppOpenAd();
      }
    } catch (e) {
      debugPrint("Failed to initialize remote config: $e");
    }
  }

  void _displayAdIfAvailable() {
    if (_canDisplayAd && _currentAd != null) {
      _currentAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (_) {
          isAdVisible.value = true;
        },
        onAdDismissedFullScreenContent: (_) {
          _resetAd();
        },
        onAdFailedToShowFullScreenContent: (_, error) {
          debugPrint("AppOpenAd error: $error");
          _resetAd();
        },
      );
      _currentAd!.show();
      _resetAd();
    } else {
      debugPrint("AppOpenAd not ready or blocked.");
      _loadAppOpenAd();
    }
  }

  void _resetAd() {
    _currentAd = null;
    _canDisplayAd = false;
    isAdVisible.value = false;
  }

  void _loadAppOpenAd() {
    AppOpenAd.load(
      adUnitId: _getAdUnitId(),
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _currentAd = ad;
          _canDisplayAd = true;
        },
        onAdFailedToLoad: (error) {
          debugPrint("Failed to load AppOpenAd: $error");
          _canDisplayAd = false;
        },
      ),
    );
  }

  String _getAdUnitId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/9257395921';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/5662855259';
    } else {
      throw UnsupportedError('Platform not supported');
    }
  }
}
