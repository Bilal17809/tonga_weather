import 'package:get/get.dart';
import '../../../ads_manager/banner_ads.dart';
import '../../../ads_manager/interstitial_ads.dart';
import '../../../core/global/global_services/connectivity_service.dart';
import '../../../core/global/global_controllers/condition_controller.dart';
import '../../home/controller/home_controller.dart';

class DailyForecastController extends GetxController with ConnectivityMixin {
  var forecastData = <Map<String, dynamic>>[].obs;
  final homeController = Get.find<HomeController>();
  final conditionController = Get.find<ConditionController>();
  var selectedDayIndex = 0.obs;
  var selectedCityName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    Get.find<InterstitialAdController>().checkAndShowAd();
    Get.find<BannerAdController>().loadBannerAd('ad2');
    loadForecastData();
  }

  @override
  void onReady() {
    super.onReady();
    initWithConnectivityCheck(
      context: Get.context!,
      onConnected: () async {
        loadForecastData();
      },
    );
  }

  void loadForecastData() {
    selectedCityName.value = homeController.selectedCityName;
    forecastData.value = conditionController.weeklyForecast;
  }

  Map<String, dynamic>? get selectedDayData =>
      forecastData.isNotEmpty && selectedDayIndex.value < forecastData.length
      ? forecastData[selectedDayIndex.value]
      : null;

  String get cityName => selectedCityName.value;

  int get totalDays => forecastData.length;

  bool get hasForecastData => forecastData.isNotEmpty;
}
