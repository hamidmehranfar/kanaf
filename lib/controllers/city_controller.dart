import '/controllers/api_controller.dart';
import '/res/enums/api_method.dart';
import '/models/address.dart';

class CityController {
  List<Address> _cities = [];

  String _apiMessage = '';

  List<Address> get cities => _cities;

  String get apiMessage => _apiMessage;

  Future<bool> fetchCities() async {
    bool result = false;

    await ApiController.instance.request(
      //FIXME : fix url
      url: '',
      method: ApiMethod.get,
      onSuccess: (response) {},
      onCatchDioError: (e) {},
      onCatchError: (e) {},
    );

    return result;
  }

  int getCityByName(String name) {
    for (var city in _cities) {
      if (name == city.name) {
        return city.id;
      }
    }
    return -1;
  }
}
