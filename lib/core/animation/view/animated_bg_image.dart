import 'package:flutter/material.dart';
import 'package:tonga_weather/core/constants/constant.dart';
import '/core/theme/theme.dart';
import 'package:tonga_weather/core/utils/weather_utils.dart';

class AnimatedBgImage extends StatelessWidget {
  final String weatherType;

  const AnimatedBgImage({super.key, required this.weatherType});

  @override
  Widget build(BuildContext context) {
    final bgPath = WeatherUtils.getWeatherBgPath(weatherType);
    return SizedBox(
      width: mobileWidth(context) * 2,
      height: mobileHeight(context),
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(bgPath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              secondaryColorLight.withValues(alpha: 0.34),
              BlendMode.hardLight,
            ),
          ),
        ),
      ),
    );
  }
}
