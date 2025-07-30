import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';
import '../core/theme/app_theme.dart';
import 'app_open_ads.dart';

class BannerAdController extends GetxController {
  final Map<String, BannerAd> _ads = {};
  final Map<String, RxBool> _adLoaded = {};
  RxBool isAdEnabled = true.obs;
  final AppOpenAdController openAdController = Get.put(AppOpenAdController());

  String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  void loadBannerAd(String key) async {
    if (_ads.containsKey(key)) {
      _ads[key]!.dispose();
    }
    final screenWidth = Get.context!.mediaQuerySize.width.toInt();

    final bannerAd = BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize(height: 55, width: screenWidth),
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _adLoaded[key] = true.obs;
          debugPrint("Banner Ad Loaded for key: $key");
        },
        onAdFailedToLoad: (ad, error) {
          _adLoaded[key] = false.obs;
          debugPrint("Ad failed to load for key $key: ${error.message}");
        },
      ),
    );

    bannerAd.load();
    _ads[key] = bannerAd;
  }

  @override
  void onClose() {
    for (final ad in _ads.values) {
      ad.dispose();
    }
    super.onClose();
  }

  Widget getBannerAdWidget(String key) {
    if (openAdController.isShowingOpenAd.value) {
      return const SizedBox();
    }
    if (isAdEnabled.value &&
        _ads.containsKey(key) &&
        _adLoaded[key]?.value == true) {
      return SafeArea(
        top: false,
        bottom: true,
        left: false,
        right: false,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 2),
            borderRadius: BorderRadius.circular(2),
          ),
          height: _ads[key]!.size.height.toDouble(),
          width: double.infinity,
          child: AdWidget(ad: _ads[key]!),
        ),
      );
    } else {
      return SafeArea(
        top: false,
        bottom: true,
        left: false,
        right: false,
        child: Shimmer.fromColors(
          baseColor: getBgColor(Get.context!),
          highlightColor: getPrimaryColor(Get.context!),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        ),
      );
    }
  }
}
