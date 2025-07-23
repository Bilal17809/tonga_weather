import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constant.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../gen/assets.gen.dart';
import '../../../daily_forecast/view/daily_forecast_view.dart';

class WeatherBody extends StatelessWidget {
  const WeatherBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        children: [
          Image.asset(Assets.homeIcon.path, width: mobileWidth(context) * 0.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => Get.to(() => const DailyForecastView()),
                child: Text(
                  '7 Day Forecast >',
                  style: headlineSmallStyle(
                    context,
                  ).copyWith(color: getButtonTextColor(context)),
                ),
              ),
            ],
          ),
          const SizedBox(height: kElementInnerGap),
          const _HourlyForecastList(),
        ],
      ),
    );
  }
}

class _HourlyForecastList extends StatelessWidget {
  const _HourlyForecastList();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: mobileHeight(context) * 0.14,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 24,
        itemBuilder: (context, index) {
          final todayMidnight = DateTime.now().copyWith(hour: 0, minute: 0);
          final hour = todayMidnight.add(Duration(hours: index));
          final hourLabel = TimeOfDay.fromDateTime(hour).format(context);

          return _HourlyForecast(
            day: hourLabel,
            isSelected: index == 0,
            isFirst: index == 0,
            isLast: index == 23,
          );
        },
      ),
    );
  }
}

class _HourlyForecast extends StatelessWidget {
  final String day;
  final bool isSelected;
  final bool isFirst;
  final bool isLast;
  // final ForecastModel? forecastData;

  const _HourlyForecast({
    required this.day,
    required this.isSelected,
    this.isFirst = false,
    this.isLast = false,
    // this.forecastData,
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
                style: titleSmallBoldStyle(context).copyWith(color: kWhite),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(height: kElementInnerGap),
            // forecastData?.iconUrl.isNotEmpty == true
            //     ? Image.network(
            //   forecastData!.iconUrl,
            //   width: primaryIcon(context),
            //   height: primaryIcon(context),
            //   fit: BoxFit.contain,
            // )
            //      :
            Icon(Icons.wb_sunny, size: primaryIcon(context), color: kWhite),
            const SizedBox(height: kElementInnerGap),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                // forecastData != null
                //     ? '${forecastData!.maxTemp.round()}°/${forecastData!.minTemp.round()}°'
                //      :
                '0°/0°',
                style: titleSmallBoldStyle(context).copyWith(color: kWhite),
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
