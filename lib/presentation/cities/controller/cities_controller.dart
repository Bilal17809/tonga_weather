import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CitiesController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  var hasSearchError = false.obs;
  var searchErrorMessage = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
  }
}
