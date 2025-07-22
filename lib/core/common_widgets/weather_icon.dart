// import 'package:flutter/material.dart';
// import '../../gen/assets.gen.dart';
//
// class WeatherIcon extends StatelessWidget {
//   final dynamic weatherData;
//   final String iconUrl;
//   final double size;
//
//   const WeatherIcon({
//     super.key,
//     required this.weatherData,
//     required this.iconUrl,
//     required this.size,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: size,
//       height: size,
//       child: FittedBox(
//         fit: BoxFit.fill,
//         child: Image.network(
//           iconUrl,
//           width: size * 0.8,
//           height: size * 0.8,
//           fit: BoxFit.contain,
//           errorBuilder: (context, error, stackTrace) {
//             return Image.asset(
//               Assets.images.cloudy.path,
//               width: size * 0.8,
//               height: size * 0.8,
//               fit: BoxFit.contain,
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
