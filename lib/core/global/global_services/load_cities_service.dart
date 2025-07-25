import 'dart:convert';
import 'package:flutter/services.dart';

import '../../../data/model/city_model.dart';
import '../../../gen/assets.gen.dart';

class LoadCitiesService {
  Future<List<CityModel>> loadAllCities() async {
    final String response = await rootBundle.loadString(Assets.cities);
    final List<dynamic> data = json.decode(response);
    return data.map((city) => CityModel.fromJson(city)).toList();
  }
}
