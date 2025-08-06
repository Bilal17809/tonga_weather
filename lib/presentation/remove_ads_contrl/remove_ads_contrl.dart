import 'package:get/get.dart';
import '../../core/local_storage/local_storage.dart';

class RemoveAds extends GetxController {
  var isSubscribedGet = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkSubscriptionStatus();
  }

  Future<void> checkSubscriptionStatus() async {
    final prefs = LocalStorage();
    final isSubscribed = await prefs.getBool('SubscribeTonga') ?? false;
    isSubscribedGet.value = isSubscribed;
  }
}
