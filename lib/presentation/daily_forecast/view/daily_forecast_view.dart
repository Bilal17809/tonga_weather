import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tonga_weather/core/utils/date_time_util.dart';
import 'package:tonga_weather/presentation/daily_forecast/view/widgets/triangle.dart';
import '../../../ads_manager/banner_ads.dart';
import '../../../ads_manager/interstitial_ads.dart';
import '../../../core/theme/app_colors.dart';
import '../../../animation/view/animated_bg_builder.dart';
import '../controller/daily_forecast_controller.dart';
import '../../../core/common_widgets/custom_appbar.dart';
import '../../../core/common_widgets/icon_buttons.dart';
import '../../../core/constants/constant.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../cities/view/cities_view.dart';

class DailyForecastView extends StatelessWidget {
  const DailyForecastView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DailyForecastController());

    return Scaffold(
      body: Obx(
        () => Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedBgImageBuilder(),
            Container(
              height: mobileHeight(context) * 0.5,
              decoration: roundedBottomDecor(context),
              child: SafeArea(
                child: Column(
                  children: [
                    CustomAppBar(
                      subtitle: '',
                      actions: [
                        IconActionButton(
                          onTap: () => Get.to(const CitiesView()),
                          icon: Icons.add,
                          color: getIconColor(context),
                          size: secondaryIcon(context),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(kBodyHp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: getIconColor(context),
                                size: secondaryIcon(context),
                              ),
                            ],
                          ),
                          const SizedBox(width: kElementInnerGap),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.cityName.toUpperCase(),
                                style: headlineSmallStyle(context),
                              ),
                              Text(
                                DateTimeUtils.getFormattedCurrentDate(),
                                style: bodyLargeStyle(context),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: mobileHeight(context) * 0.21,
              left: kBodyHp,
              right: kBodyHp,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Transform.translate(
                      offset: Offset(-mobileWidth(context) * 0.24, 0),
                      child: CustomPaint(
                        painter: TrianglePainter(context),
                        child: SizedBox(
                          height: smallIcon(context),
                          width: smallIcon(context),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(kBodyHp),
                      decoration: roundedForecastDecor(
                        context,
                      ).copyWith(borderRadius: BorderRadius.circular(24)),
                      child: Column(
                        children: [
                          Text(
                            '7 Day Forecast',
                            style: titleBoldLargeStyle(context),
                          ),
                          const SizedBox(height: kElementGap),
                          if (controller.hasForecastData)
                            ...controller.forecastData.map(
                              (dayData) => _ForecastRow(
                                day: dayData['day'] ?? '',
                                iconUrl: dayData['iconUrl'] ?? '',
                                maxTemp: dayData['temp']?.round() ?? 0,
                                minTemp: dayData['minTemp']?.round() ?? 0,
                                condition: dayData['condition'] ?? '',
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Get.find<InterstitialAdController>().isAdReady
          ? const SizedBox()
          : Obx(() => Get.find<BannerAdController>().getBannerAdWidget('ad2')),
    );
  }
}

class _ForecastRow extends StatelessWidget {
  final String day;
  final String iconUrl;
  final int maxTemp;
  final int minTemp;
  final String condition;

  const _ForecastRow({
    required this.day,
    required this.iconUrl,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: kBodyHp,
        horizontal: kElementGap,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: mobileWidth(context) * 0.15,
            child: Text(day, style: bodyMediumStyle(context)),
          ),
          iconUrl.isNotEmpty
              ? Image.network(
                  iconUrl.startsWith('http') ? iconUrl : 'https:$iconUrl',
                  width: mediumIcon(context),
                  height: mediumIcon(context),
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.wb_sunny,
                    size: mediumIcon(context),
                    color: kWhite,
                  ),
                )
              : Icon(Icons.wb_sunny, size: mediumIcon(context)),
          Spacer(),
          Text(
            '$maxTemp°/$minTemp°',
            style: bodyMediumStyle(context),
            textAlign: TextAlign.center,
          ),
          SizedBox(width: mobileWidth(context) * 0.08),
          Flexible(
            flex: 2,
            child: Text(
              condition,
              style: bodyMediumStyle(context),
              textAlign: TextAlign.start,
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
