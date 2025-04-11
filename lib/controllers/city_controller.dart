import 'package:get/get.dart';
import 'package:kanaf/models/city.dart';
import 'package:kanaf/models/province.dart';
import 'package:kanaf/res/shared_storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/controllers/api_controller.dart';
import '/res/enums/api_method.dart';

class CityController extends GetxController {
  List<Province> _provinces = [];

  City? _selectedCity;

  String _apiMessage = '';

  List<Province> get provinces => _provinces;

  String get apiMessage => _apiMessage;

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

  Future<void> getSavedCity(String name) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.containsKey(SharedPreferenceKeys.savedCity)) {
      int? saved = pref.getInt(SharedPreferenceKeys.savedCity);
      bool cityExist = false;

      if (!cityExist) {
        _selectedCity = null;
      }
    }
  }

  Future<void> saveSelectedCity(City city) async {
    _selectedCity = city;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(SharedPreferenceKeys.savedCity, city.id);
  }
}
