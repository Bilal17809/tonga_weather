import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:tonga_weather/core/local_storage/local_storage.dart';
import '../../../data/model/city_model.dart';
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

  Future<void> saveSelectedCities(List<CityModel> cities) async {
    try {
      final citiesJson = json.encode(cities.map((c) => c.toJson()).toList());
      await localStorage.setString('selected_cities', citiesJson);
    } catch (e) {
      debugPrint('${AppExceptions().failToSave}: $e');
    }
  }

  Future<List<CityModel>> loadSelectedCities(CityModel? fallbackCity) async {
    try {
      final selectedCitiesJson = await localStorage.getString(
        'selected_cities',
      );
      if (selectedCitiesJson != null) {
        final List<dynamic> citiesData = json.decode(selectedCitiesJson);
        return citiesData.map((data) => CityModel.fromJson(data)).toList();
      } else if (fallbackCity != null) {
        // Save fallbackCity as initial selection
        final fallbackList = [fallbackCity];
        await saveSelectedCities(fallbackList);
        return fallbackList;
      }
    } catch (e) {
      debugPrint('${AppExceptions().failToLoad}: $e');
    }

    return [];
  }
}
