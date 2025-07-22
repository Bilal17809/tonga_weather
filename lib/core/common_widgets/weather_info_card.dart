// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../../core/constants/constant.dart';
// import '../../core/theme/app_colors.dart';
// import '../../core/theme/app_styles.dart';
// import '../../core/utils/weather_utils.dart';
//
// class WeatherInfoCard extends StatelessWidget {
//   final DateTime? date;
//   final String temperature;
//   final String condition;
//   final String minTemp;
//   final String? maxTemp;
//   final WeatherModel? weatherData;
//   final double? iconSize;
//   final String imagePath;
//
//   const WeatherInfoCard({
//     super.key,
//     this.date,
//     required this.temperature,
//     required this.condition,
//     required this.minTemp,
//     required this.weatherData,
//     this.iconSize,
//     required this.imagePath,
//     this.maxTemp,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final textColor = getTextColor(context);
//     final String humidity = '${weatherData!.humidity}%';
//     final String windSpeed = '${weatherData!.windSpeed.toStringAsFixed(1)}km/h';
//     final String precipitation = '${weatherData!.chanceOfRain}%';
//
//     return Container(
//       decoration: roundedDecorationWithShadow(context).copyWith(
//         color:
//             isDarkMode(context) ? kWhite.withValues(alpha: 0.2) : kLightWhite,
//       ),
//       padding: kContentPaddingSmall,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           if (date != null)
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   DateFormat.EEEE().format(date!),
//                   style: headlineSmallStyle(context).copyWith(color: textColor),
//                 ),
//               ],
//             ),
//           FittedBox(
//             fit: BoxFit.scaleDown,
//             child: Row(
//               children: [
//                 SizedBox(
//                   width: iconSize ?? largeIcon(context),
//                   height: iconSize ?? largeIcon(context),
//                   child: AnimatedWeatherIcon(
//                     imagePath: imagePath,
//                     condition: condition,
//                     width: iconSize ?? largeIcon(context),
//                   ),
//                 ),
//                 SizedBox(width: kElementGap),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     FittedBox(
//                       fit: BoxFit.scaleDown,
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             temperature,
//                             style: headlineLargeStyle(
//                               context,
//                             ).copyWith(color: textColor),
//                           ),
//                           Text(
//                             '°',
//                             style: headlineLargeStyle(
//                               context,
//                             ).copyWith(color: textColor, fontSize: 50),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Center(
//                       child: FittedBox(
//                         fit: BoxFit.scaleDown,
//                         child: Text(
//                           condition,
//                           style: titleBoldLargeStyle(
//                             context,
//                           ).copyWith(color: textColor),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 5),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         FittedBox(
//                           fit: BoxFit.scaleDown,
//                           child: Text(
//                             '$maxTemp°',
//                             style: titleBoldMediumStyle(
//                               context,
//                             ).copyWith(color: textColor),
//                           ),
//                         ),
//                         FittedBox(
//                           fit: BoxFit.scaleDown,
//                           child: Text(
//                             '/$minTemp°',
//                             style: titleBoldMediumStyle(
//                               context,
//                             ).copyWith(color: textColor),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 5),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           ...[
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: kElementWidthGap),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Expanded(
//                     child: WeatherDetailItem(
//                       icon: WeatherUtils.getHomeIcon('precipitation'),
//                       value: precipitation,
//                       label: 'Precipitation',
//                     ),
//                   ),
//                   Expanded(
//                     child: WeatherDetailItem(
//                       icon: WeatherUtils.getHomeIcon('humidity'),
//                       value: humidity,
//                       label: 'Humidity',
//                     ),
//                   ),
//                   Expanded(
//                     child: WeatherDetailItem(
//                       icon: WeatherUtils.getHomeIcon('wind'),
//                       value: windSpeed,
//                       label: 'Wind',
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }
