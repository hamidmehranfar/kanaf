import 'package:get/get.dart';

import '/controllers/api_controller.dart';
import '/models/master.dart';
import '/res/enums/api_method.dart';

class MasterController extends GetxController{
  List<Master> _masters = [];

  String _apiMessage = "";

  String get apiMessage => _apiMessage;

  List<Master> get masters => _masters;

  Future<bool> getMastersList(int pageKey) async {
    bool result = false;

    await ApiController.instance.request(
      url: "master/profile",
      method: ApiMethod.get,
      onSuccess: (response){
        _masters = [];
        for(var item in response.data){
          _masters.add(Master.fromJson(item));
        }
        result = true;
      },
      onCatchDioError: (e){
        _apiMessage = e.response?.data["detail"] ?? "";
      },
      onCatchError: (e){
        _apiMessage = "مشکلی پیش امده است";
      }
    );

    return result;
  }

  Future<Master?> getMaster(int id) async {
    Master? master;

    await ApiController.instance.request(
        url: "master/profile/$id",
        method: ApiMethod.get,
        onSuccess: (response){
          master = Master.fromJson(response.data);
        },
        onCatchDioError: (e){
          _apiMessage = e.response?.data["detail"] ?? "";
        },
        onCatchError: (e){
          _apiMessage = "مشکلی پیش امده است";
        }
    );

    return master;
  }

  Future<bool> editMaster(Master master) async {
    Map payload = {
      "degree": master.degree,
      "payment": master.payment,
      "is_master": master.isMaster,
      "is_painter": master.isPainter,
      "is_light_line": master.isLightLine,
      "is_electric": master.isElectric,
      "bio": master.bio,
      "birthday": master.birthDate.toString(),
      "work_experience": master.workExperience,
      "work_hours_start": master.workHourStart,
      "works_hours_end": master.workHourEnd,
      "city": master.city.id,
    };

    bool result = false;

    await ApiController.instance.request(
        url: "master/profile/${master.id}/",
        data: payload,
        method: ApiMethod.patch,
        onSuccess: (response){
          result = true;
        },
        onCatchDioError: (e){
          _apiMessage = e.response?.data["detail"] ?? "";
        },
        onCatchError: (e){
          _apiMessage = "مشکلی پیش امده است";
        }
    );

    return result;
  }

  Future<bool> deleteMaster(int id) async {
    bool result = false;

    await ApiController.instance.request(
        url: "master/profile/$id/",
        method: ApiMethod.delete,
        onSuccess: (response){
          result = true;
        },
        onCatchDioError: (e){
          _apiMessage = e.response?.data["detail"] ?? "";
        },
        onCatchError: (e){
          _apiMessage = "مشکلی پیش امده است";
        }
    );

    return result;
  }
}