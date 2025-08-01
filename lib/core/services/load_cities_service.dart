import 'dart:convert';
import 'package:flutter/services.dart';

import '../../data/model/city_model.dart';

class LoadCitiesService {
  Future<List<CityModel>> loadAllCities() async {
    final String response = await rootBundle.loadString('assets/cities.json');
    final List<dynamic> data = json.decode(response);
    return data.map((city) => CityModel.fromJson(city)).toList();
  }
}
