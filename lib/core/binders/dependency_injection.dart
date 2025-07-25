import 'package:get/get.dart';
import 'package:tonga_weather/core/global/global_services/load_cities_service.dart';
import '../../data/data_source/online_data_sr.dart';
import '../../data/repo/weather_api_impl.dart';
import '../../domain/repositories/weather_repo.dart';
import '../../domain/use_cases/get_current_weather.dart';
import '../../presentation/cities/controller/cities_controller.dart';
import '../../presentation/home/controller/home_controller.dart';
import '../../presentation/splash/controller/splash_controller.dart';
import '../global/global_controllers/condition_controller.dart';
import '../global/global_services/city_storage_service.dart';
import '../global/global_services/connectivity_service.dart';
import '../global/global_services/current_location_service.dart';
import '../global/global_keys/global_key.dart';
import '../global/global_services/load_weather_service.dart';
import '../local_storage/local_storage.dart';

class DependencyInjection {
  static void init() {
    /// Core services
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

    /// Location and local storage
    Get.lazyPut<LocalStorage>(() => LocalStorage(), fenix: true);
    Get.lazyPut(
      () => CurrentLocationService(
        localStorage: Get.find(),
        getCurrentWeather: Get.find<GetWeatherAndForecast>(),
      ),
    );
    Get.lazyPut(() => CityStorageService(localStorage: Get.find()));

    /// Cities and weather loading service
    Get.lazyPut<LoadCitiesService>(() => LoadCitiesService());
    Get.lazyPut<LoadWeatherService>(
      () => LoadWeatherService(
        getCurrentWeather: Get.find(),
        conditionController: Get.find(),
      ),
    );

    /// Controllers
    Get.lazyPut(
      () => SplashController(
        getCurrentWeather: Get.find(),
        localStorage: Get.find(),
        currentLocationService: Get.find(),
        cityService: Get.find(),
        cityStorageService: Get.find(),
        loadWeatherService: Get.find(),
      ),
    );

    Get.lazyPut<ConditionController>(() => ConditionController(), fenix: true);
    Get.lazyPut<HomeController>(
      () => HomeController(Get.find<GetWeatherAndForecast>()),
      fenix: true,
    );
    Get.lazyPut<CitiesController>(() => CitiesController(), fenix: true);
  }
}
