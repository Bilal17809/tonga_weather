import 'package:get/get.dart';
import 'package:tonga_weather/core/global/global_services/weather_service.dart';
import '../../data/data_source/online_data_sr.dart';
import '../../data/repo/weather_api_impl.dart';
import '../../domain/repositories/weather_repo.dart';
import '../../domain/use_cases/get_current_weather.dart';
import '../../presentation/cities/controller/cities_controller.dart';
import '../../presentation/home/controller/home_controller.dart';
import '../../presentation/splash/controller/splash_controller.dart';
import '../global/global_controllers/condition_controller.dart';
import '../global/global_services/connectivity_service.dart';
import '../global/global_services/global_key.dart';

class DependencyInjection {
  static void init() {
    Get.lazyPut<ConnectivityService>(() => ConnectivityService(), fenix: true);
    Get.lazyPut<OnlineDataSource>(() => OnlineDataSource(apiKey), fenix: true);
    Get.lazyPut<WeatherRepo>(
      () => WeatherApiImpl(Get.find<OnlineDataSource>()),
      fenix: true,
    );
    Get.lazyPut<GetWeatherAndForecast>(
      () => GetWeatherAndForecast(Get.find<WeatherRepo>()),
      fenix: true,
    );
    Get.put<WeatherService>(WeatherService(), permanent: true);
    Get.lazyPut<SplashController>(
      () => SplashController(Get.find<GetWeatherAndForecast>()),
      fenix: true,
    );
    Get.lazyPut<ConditionController>(() => ConditionController(), fenix: true);
    Get.lazyPut<HomeController>(
      () => HomeController(Get.find<GetWeatherAndForecast>()),
      fenix: true,
    );
    Get.lazyPut<CitiesController>(() => CitiesController(), fenix: true);
  }
}
