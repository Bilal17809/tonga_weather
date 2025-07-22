// import '../../gen/assets.gen.dart';
//
// class WeatherUtils {
//   static const String _defaultIconUrl =
//       'https://cdn.weatherapi.com/weather/128x128/day/116.png';
//
//   static final Map<String, String> _homeIcons = {
//     'precipitation': Assets.images.precipitationUmbrella.path,
//     'humidity': Assets.images.humidityDroplet.path,
//     'wind': Assets.images.windy.path,
//   };
//
//   static final Map<String, String> _weatherIcon = {
//     'clear': Assets.images.clear.path,
//     'cloudy': Assets.images.cloudy.path,
//     'rain': Assets.images.rain.path,
//     'snow': Assets.images.snow.path,
//     'thunderstorm': Assets.images.thunderstorm.path,
//     'sleet': Assets.images.sleet.path,
//   };
//
//   static String getWeatherIcon(int code) {
//     if ([1000].contains(code)) return 'clear';
//     if ([1087, 1273, 1276, 1279, 1282].contains(code)) return 'thunderstorm';
//     if ([1003, 1006, 1009, 1030, 1135, 1147].contains(code)) return 'cloudy';
//     if ([
//       1063,
//       1150,
//       1153,
//       1180,
//       1183,
//       1186,
//       1189,
//       1192,
//       1195,
//       1240,
//       1243,
//       1246,
//     ].contains(code)) {
//       return 'rain';
//     }
//     if ([
//       1066,
//       1210,
//       1213,
//       1216,
//       1219,
//       1222,
//       1225,
//       1255,
//       1258,
//       1114,
//       1117,
//     ].contains(code)) {
//       return 'snow';
//     }
//     if ([
//       1069,
//       1072,
//       1168,
//       1171,
//       1198,
//       1201,
//       1204,
//       1207,
//       1249,
//       1252,
//       1237,
//       1261,
//       1264,
//     ].contains(code)) {
//       return 'sleet';
//     }
//     return 'clear';
//   }
//
//   static String getDefaultIcon() => _defaultIconUrl;
//
//   static String getHomeIcon(String type) {
//     return _homeIcons[type.toLowerCase()] ?? '';
//   }
//
//   static String getWeatherIconPath(String weatherType) {
//     return _weatherIcon[weatherType.toLowerCase()] ?? _weatherIcon['clear']!;
//   }
// }
