import 'package:get/get.dart';
import '/core/mixins/connectivity_mixin.dart';
import '/ads_manager/banner_ads.dart';
import '/ads_manager/interstitial_ads.dart';
import '/core/services/services.dart';
import '/presentation/home/controller/home_controller.dart';

class DailyForecastController extends GetxController with ConnectivityMixin {
  var forecastData = <Map<String, dynamic>>[].obs;
  final homeController = Get.find<HomeController>();
  final conditionController = Get.find<ConditionService>();
  var selectedDayIndex = 0.obs;
  var selectedCityName = ''.obs;

  @override
  void onReady() {
    super.onReady();
    initWithConnectivityCheck(
      context: Get.context!,
      onConnected: () async {
        Get.find<InterstitialAdManager>().checkAndDisplayAd();
        Get.find<BannerAdManager>().loadBannerAd('ad2');
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
