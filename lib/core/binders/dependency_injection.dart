import 'package:get/get.dart';
import 'package:tonga_weather/core/config/client.dart';
import 'package:tonga_weather/core/services/weather_codes_loader.dart';
import 'package:tonga_weather/presentation/daily_forecast/controller/daily_forecast_controller.dart';
import '/core/services/services.dart';
import '/ads_manager/ads_manager.dart';
import '/data/data_source/online_data_sr.dart';
import '/data/repo/weather_api_impl.dart';
import '/domain/repositories/weather_repo.dart';
import '/domain/use_cases/use_case.dart';
import '/presentation/cities/controller/cities_controller.dart';
import '/presentation/home/controller/home_controller.dart';
import '/presentation/splash/controller/splash_controller.dart';
import '../animation/controller/bg_animation_controller.dart';
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
    Get.putAsync<WeatherCodesLoader>(() async {
      final loader = WeatherCodesLoader();
      await loader.loadWeatherCodes();
      return loader;
    });

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
    Get.lazyPut<BgAnimationController>(
      () => BgAnimationController(),
      fenix: true,
    );
    Get.lazyPut<ConditionService>(() => ConditionService(), fenix: true);
    Get.lazyPut<HomeController>(
      () => HomeController(Get.find<GetWeatherAndForecast>()),
      fenix: true,
    );
    Get.lazyPut<CitiesController>(() => CitiesController(), fenix: true);
    Get.lazyPut<DailyForecastController>(
      () => DailyForecastController(),
      fenix: true,
    );

    /// Ads
    Get.lazyPut<BannerAdManager>(() => BannerAdManager(), fenix: true);
    Get.lazyPut<InterstitialAdManager>(
      () => InterstitialAdManager(),
      fenix: true,
    );
  }
}
