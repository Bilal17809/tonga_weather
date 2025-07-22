import 'package:get/get.dart';
import '../../presentation/home/controller/home_controller.dart';

class DependencyInjection {
  static void init() {
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
  }
}
