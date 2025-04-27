import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/models/city.dart';
import '/models/province.dart';
import '/res/shared_preference_keys.dart';
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

  set selectedProvince(Province? province) => _selectedProvince = province;

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

  Future<void> getSavedProvince() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.containsKey(SharedPreferenceKeys.savedProvince)) {
      int? saved = pref.getInt(SharedPreferenceKeys.savedProvince);
      if (saved != null) {
        getProvinceById(saved);
      }
    }
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

  Future<void> saveSelectedProvince(Province province) async {
    _selectedProvince = province;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(SharedPreferenceKeys.savedProvince, province.id);
  }

  Future<void> saveSelectedCity(City city) async {
    _selectedCity = city;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(SharedPreferenceKeys.savedCity, city.id);
  }

  Future<void> removeSelectedProvince() async {
    _selectedProvince = null;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(SharedPreferenceKeys.savedProvince);
  }

  Future<void> removeSelectedCity() async {
    _selectedCity = null;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(SharedPreferenceKeys.savedCity);
  }

  void getProvinceById(int id) {
    for (var province in _provinces) {
      if (province.id == id) {
        _selectedProvince = province;
        break;
      }
    }
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
