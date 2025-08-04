import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/ads_manager/ads_manager.dart';
import '/core/services/services.dart';
import 'package:tonga_weather/presentation/daily_forecast/view/widgets/triangle.dart';
import '/core/animation/view/animated_bg_builder.dart';
import '/core/theme/theme.dart';
import '../controller/daily_forecast_controller.dart';
import 'package:tonga_weather/core/common_widgets/common_widgets.dart';
import '/core/constants/constant.dart';
import '/presentation/cities/view/cities_view.dart';
import 'widgets/forecast_row.dart';

class DailyForecastView extends StatelessWidget {
  const DailyForecastView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DailyForecastController>();

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
                    TitleBar(
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
                                DateTimeService.getFormattedCurrentDate(),
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
            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: mobileHeight(context) * 0.21,
                  left: kBodyHp,
                  right: kBodyHp,
                  bottom: kElementInnerGap,
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
                                  (dayData) => ForecastRow(
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
          ],
        ),
      ),
      bottomNavigationBar: Obx(() {
        return Get.find<InterstitialAdManager>().isShow.value
            ? SizedBox()
            : Get.find<BannerAdManager>().showBannerAd('ad2');
      }),
    );
  }
}
