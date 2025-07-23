import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tonga_weather/presentation/daily_forecast/view/widgets/triangle.dart';
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
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
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
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ISLAMABAD',
                              style: headlineSmallStyle(context),
                            ),
                            Text(
                              'Monday June 23',
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
            top: mobileHeight(context) * 0.22,
            left: kBodyHp,
            right: kBodyHp,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Transform.translate(
                  offset: Offset(-mobileWidth(context) * 0.2, 0),
                  child: CustomPaint(
                    painter: TrianglePainter(context),
                    child: const SizedBox(height: 20, width: 20),
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
                      for (var day in _forecast)
                        _ForecastRow(
                          day: day['day']!,
                          icon: day['icon']!,
                          temp: day['temp']!,
                          desc: day['desc']!,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ForecastRow extends StatelessWidget {
  final String day;
  final String icon;
  final String temp;
  final String desc;

  const _ForecastRow({
    required this.day,
    required this.icon,
    required this.temp,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: kBodyHp,
        horizontal: kElementGap,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 35,
            child: Text(day, style: bodyMediumStyle(context)),
          ),
          Text(icon, style: titleBoldLargeStyle(context)),
          Text(temp, style: bodyMediumStyle(context)),
          Text(desc, style: bodyMediumStyle(context)),
        ],
      ),
    );
  }
}

const _forecast = [
  {'day': 'Mon', 'icon': '🌤️', 'temp': '29°', 'desc': 'Partly cloudy'},
  {'day': 'Tue', 'icon': '🌤️', 'temp': '29°', 'desc': 'Partly cloudy'},
  {'day': 'Wed', 'icon': '🌤️', 'temp': '29°', 'desc': 'Partly cloudy'},
  {'day': 'Thu', 'icon': '🌤️', 'temp': '29°', 'desc': 'Partly cloudy'},
  {'day': 'Fri', 'icon': '🌤️', 'temp': '29°', 'desc': 'Partly cloudy'},
  {'day': 'Sat', 'icon': '🌤️', 'temp': '29°', 'desc': 'Partly cloudy'},
  {'day': 'Sun', 'icon': '🌤️', 'temp': '29°', 'desc': 'Partly cloudy'},
];
