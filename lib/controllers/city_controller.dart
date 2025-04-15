import 'package:get/get.dart';
import 'package:kanaf/models/city.dart';
import 'package:kanaf/models/province.dart';
import 'package:kanaf/res/shared_preference_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/controllers/api_controller.dart';
import '/res/enums/api_method.dart';

class CityController extends GetxController {
  List<Province> _provinces = [];

  Province? _selectedProvince;
  City? _selectedCity;

  String _apiMessage = '';

  List<Province> get provinces => _provinces;

  String get apiMessage => _apiMessage;

  Province? get selectedProvince => _selectedProvince;

  City? get selectedCity => _selectedCity;

  set selectedCity(City? city) => _selectedCity = city;

  Future<bool> fetchCities() async {
    bool result = false;

    await ApiController.instance.request(
      url: 'core/provinces/',
      method: ApiMethod.get,
      onSuccess: (response) {
        _provinces.clear();
        for (var value in response.data["results"]) {
          _provinces.add(Province.fromJson(value));
        }
        result = true;
      },
      onCatchDioError: (e) {
        _apiMessage = e.response?.data['detail'] ?? '';
      },
      onCatchError: (e) {
        _apiMessage = 'مشکلی پیش آمده است';
      },
    );

    return result;
  }

  Future<void> getSavedCity() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.containsKey(SharedPreferenceKeys.savedCity)) {
      int? saved = pref.getInt(SharedPreferenceKeys.savedCity);
      if (saved != null) {
        getAddressByCityId(saved);
      }
    }
  }

  Future<void> saveSelectedCity(City city) async {
    _selectedCity = city;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(SharedPreferenceKeys.savedCity, city.id);
  }

  void getAddressByCityId(int id) {
    for (var province in _provinces) {
      for (var city in province.cities) {
        if (id == city.id) {
          _selectedCity = city;
          _selectedProvince = province;
        }
      }
    }
  }
}
