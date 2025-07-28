import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tonga_weather/core/global/global_services/load_weather_service.dart';
import 'package:tonga_weather/core/utils/date_time_util.dart';
import 'package:tonga_weather/presentation/home/controller/home_controller.dart';
import '../../../../core/common_widgets/custom_appbar.dart';
import '../../../../core/common_widgets/icon_buttons.dart';
import '../../../../core/constants/constant.dart';
import '../../../../core/global/global_controllers/condition_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../gen/assets.gen.dart';
import '../../../cities/view/cities_view.dart';

class WeatherHeader extends StatelessWidget {
  const WeatherHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final weatherService = Get.find<LoadWeatherService>();
    return Obx(
      () => Container(
        decoration: roundedBottomDecor(context),
        child: SafeArea(
          child: Column(
            children: [
              CustomAppBar(
                useBackButton: false,
                title:
                    homeController.selectedCity.value?.city ?? 'Unknown City',
                subtitle: DateTimeUtils.getFormattedCurrentDate(),
                actions: [
                  IconActionButton(
                    onTap: () async {
                      final selectedCity = await Get.to(
                        () => const CitiesView(),
                      );
                      if (selectedCity != null) {
                        homeController.selectedCity.value = selectedCity;
                        await weatherService.loadWeatherForAllCities([
                          selectedCity,
                        ], selectedCity: selectedCity);
                      }
                    },
                    icon: Icons.add,
                    color: getIconColor(context),
                    size: secondaryIcon(context),
                  ),
                ],
              ),
              const _TemperatureSection(),
              const SizedBox(height: kElementGap),
              const _WeatherMetrics(),
              const SizedBox(height: kElementGap),
            ],
          ),
        ),
      ),
    );
  }
}

class _TemperatureSection extends StatelessWidget {
  const _TemperatureSection();
  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    return Obx(() {
      final selectedCity = homeController.selectedCity.value;
      final weather = selectedCity != null
          ? homeController.conditionController.allCitiesWeather[selectedCity
                .cityAscii]
          : null;

      final temp = weather?.temperature.round().toString() ?? '--';

      return Padding(
        padding: kContentPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Assets.cloudy.path, width: primaryIcon(context)),
            const SizedBox(width: kElementGap),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(temp, style: headlineLargeStyle(context)),
                Text('°', style: headlineLargeStyle(context)),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class _WeatherMetrics extends StatelessWidget {
  const _WeatherMetrics();

  @override
  Widget build(BuildContext context) {
    final conditionController = Get.find<ConditionController>();
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: mobileWidth(context) * 0.15),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    text: 'High : ${conditionController.maxTemp}° C',
                    icon: Icons.north_east,
                    iconColor: kWhite,
                  ),
                ),
                const SizedBox(width: kElementGap),
                Expanded(
                  child: _MetricCard(
                    text: 'Low : ${conditionController.minTemp}° C',
                    icon: Icons.south_east,
                    iconColor: kRed,
                  ),
                ),
              ],
            ),
            const SizedBox(height: kElementGap),
            Container(
              decoration: roundedDecor(context),
              height: 74,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _VerticalMetric(
                    title: 'Humidity',
                    value: conditionController.humidity,
                  ),
                  VerticalDivider(
                    color: kWhite,
                    thickness: 1,
                    indent: 10,
                    endIndent: 10,
                  ),
                  _VerticalMetric(
                    title: 'Wind',
                    value: conditionController.windSpeed,
                  ),
                  VerticalDivider(
                    color: kWhite,
                    thickness: 1,
                    indent: 10,
                    endIndent: 10,
                  ),
                  _VerticalMetric(
                    title: 'Rain',
                    value: conditionController.chanceOfRain,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color iconColor;

  const _MetricCard({
    required this.text,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: roundedDecor(context),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text, style: titleSmallBoldStyle(context)),
          Icon(icon, color: iconColor),
        ],
      ),
    );
  }
}

class _VerticalMetric extends StatelessWidget {
  final String title;
  final String value;

  const _VerticalMetric({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: bodyLargeStyle(context)),
        Text(value, style: titleSmallBoldStyle(context)),
      ],
    );
  }
}
