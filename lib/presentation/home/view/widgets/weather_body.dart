import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tonga_weather/presentation/splash/controller/splash_controller.dart';
import '../../../../core/common_widgets/common_shimmer.dart';
import '../../../../core/constants/constant.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../daily_forecast/view/daily_forecast_view.dart';
import '../../controller/home_controller.dart';

class WeatherBody extends StatelessWidget {
  const WeatherBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SafeArea(
        top: false,
        bottom: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => Get.to(() => const DailyForecastView()),
                  child: Text(
                    '7 Day Forecast >',
                    style: headlineSmallStyle(context).copyWith(color: kWhite),
                  ),
                ),
              ],
            ),
            const SizedBox(height: kElementInnerGap),
            const _HourlyForecastList(),
            const SizedBox(height: kBodyHp),
          ],
        ),
      ),
    );
  }
}

class _HourlyForecastList extends StatelessWidget {
  const _HourlyForecastList();
  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final splashController = Get.find<SplashController>();
    return Obx(() {
      final forecastDays =
          splashController.rawForecastData['forecast']?['forecastday'];
      final todayData = (forecastDays as List?)?.firstOrNull;
      final hourlyList = todayData?['hour'] as List? ?? [];
      final now = DateTime.now();
      final isLoading = forecastDays == null || homeController.isLoading.value;
      if (isLoading) {
        const shimmerItemCount = 24;
        return SizedBox(
          height: mobileHeight(context) * 0.14,
          child: ShimmerListView(
            itemCount: shimmerItemCount,
            itemWidth: mobileWidth(context) * 0.2,
            itemHeight: mobileHeight(context) * 0.12,
            itemMargin: (index) => EdgeInsets.only(
              left: index == 0 ? kBodyHp : 0,
              right: index == shimmerItemCount - 1 ? kBodyHp : kElementGap,
            ),
          ),
        );
      }
      return SizedBox(
        height: mobileHeight(context) * 0.14,
        child: ListView.builder(
          controller: homeController.scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: hourlyList.length,
          itemBuilder: (context, index) {
            final hourData = hourlyList[index];
            final hourTime = DateTime.parse(hourData['time']);
            final hourLabel = TimeOfDay.fromDateTime(hourTime).format(context);
            final isCurrentHour = hourTime.hour == now.hour;
            return _HourlyForecast(
              day: hourLabel,
              isSelected: isCurrentHour,
              isFirst: index == 0,
              isLast: index == hourlyList.length - 1,
              hourData: hourData,
            );
          },
        ),
      );
    });
  }
}

class _HourlyForecast extends StatelessWidget {
  final String day;
  final bool isSelected;
  final bool isFirst;
  final bool isLast;
  final Map<String, dynamic>? hourData;

  const _HourlyForecast({
    required this.day,
    required this.isSelected,
    this.isFirst = false,
    this.isLast = false,
    this.hourData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: mobileWidth(context) * 0.2,
      margin: EdgeInsets.only(
        left: isFirst ? kBodyHp : 0,
        right: isLast ? kBodyHp : kElementGap,
      ),
      padding: const EdgeInsets.symmetric(vertical: kBodyHp),
      decoration: roundedSelectionDecoration(context, isSelected: isSelected),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                day,
                style: bodyBoldMediumStyle(context).copyWith(color: kWhite),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(height: kElementInnerGap),
            hourData?['condition']?['icon'] != null
                ? Image.network(
                    'https:${hourData!['condition']['icon']}',
                    width: mediumIcon(context),
                    height: mediumIcon(context),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.wb_sunny,
                      size: primaryIcon(context),
                      color: kWhite,
                    ),
                  )
                : Icon(
                    Icons.wb_sunny,
                    size: mediumIcon(context),
                    color: kWhite,
                  ),
            const SizedBox(height: kElementInnerGap),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                hourData != null ? '${hourData!['temp_c'].round()}°' : '0°',
                style: bodyBoldMediumStyle(context).copyWith(color: kWhite),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
