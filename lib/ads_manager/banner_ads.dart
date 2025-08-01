import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';
import '/core/theme/theme.dart';
import 'app_open_ads.dart';

class BannerAdManager extends GetxController {
  final _adInstances = <String, BannerAd>{};
  final _adStatusMap = <String, RxBool>{};
  final isBannerAdEnabled = true.obs;
  final AppOpenAdManager appOpenAdManager = Get.put(AppOpenAdManager());

  String get _adUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  void loadBannerAd(String key) {
    _adInstances[key]?.dispose();

    final screenWidth = Get.context!.mediaQuerySize.width.toInt();
    final ad = BannerAd(
      adUnitId: _adUnitId,
      size: AdSize(height: 55, width: screenWidth),
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          _adStatusMap[key] = true.obs;
          debugPrint("BannerAd loaded for: $key");
        },
        onAdFailedToLoad: (_, error) {
          _adStatusMap[key] = false.obs;
          debugPrint("BannerAd load failed ($key): ${error.message}");
        },
      ),
    );

    ad.load();
    _adInstances[key] = ad;
  }

  Widget showBannerAd(String key) {
    final ad = _adInstances[key];
    final isLoaded = _adStatusMap[key]?.value ?? false;

    if (appOpenAdManager.isAdVisible.value) return const SizedBox();

    if (isBannerAdEnabled.value && ad != null && isLoaded) {
      return SafeArea(
        bottom: true,
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),
          height: ad.size.height.toDouble(),
          width: double.infinity,
          child: AdWidget(ad: ad),
        ),
      );
    } else {
      return SafeArea(
        bottom: true,
        child: Shimmer.fromColors(
          baseColor: getBgColor(Get.context!),
          highlightColor: getPrimaryColor(Get.context!),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  void onClose() {
    for (final ad in _adInstances.values) {
      ad.dispose();
    }
    super.onClose();
  }
}
