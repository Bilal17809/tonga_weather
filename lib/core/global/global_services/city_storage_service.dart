import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:tonga_weather/core/local_storage/local_storage.dart';
import '/data/model/city_model.dart';
import '../../common/app_exceptions.dart';

class CityStorageService {
  final LocalStorage localStorage;

  CityStorageService({required this.localStorage});
  Future<void> saveSelectedCity(CityModel? selectedCity) async {
    try {
      if (selectedCity != null) {
        final cityJson = json.encode(selectedCity.toJson());
        await localStorage.setString('selected_city', cityJson);
      }
    } catch (e) {
      debugPrint("${AppExceptions().failToSave}: $e");
    }
  }

  Future<CityModel> loadSelectedCity({
    required List<CityModel> allCities,
    required CityModel? currentLocationCity,
  }) async {
    try {
      final savedCityJson = await localStorage.getString('selected_city');
      if (savedCityJson != null) {
        final cityData = json.decode(savedCityJson);
        return CityModel.fromJson(cityData);
      }
      if (currentLocationCity != null) {
        return currentLocationCity;
      }
      return allCities.firstWhere(
        (city) => city.city.toLowerCase() == 'nukualofa',
        orElse: () => allCities.first,
      );
    } catch (e) {
      debugPrint("${AppExceptions().failToLoad}: $e");
      return allCities.first;
    }
  }
}
