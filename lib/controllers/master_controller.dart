import 'package:get/get.dart';
import 'package:kanaf/res/enums/master_services.dart';

import '/controllers/api_controller.dart';
import '/models/master.dart';
import '/res/enums/api_method.dart';

class MasterController extends GetxController {
  List<Master> _kanafMasters = [];
  List<Master> _painters = [];
  List<Master> _lightLines = [];
  List<Master> _electronics = [];

  Master? _master;

  String _apiMessage = "";

  String get apiMessage => _apiMessage;

  List<Master> get kanafMasters => _kanafMasters;

  List<Master> get painters => _painters;

  List<Master> get lightLines => _lightLines;

  List<Master> get electronics => _electronics;

  Master? get master => _master;

  void fillMastersList(List<Master> mastersList) {
    _kanafMasters.clear();
    _painters.clear();
    _lightLines.clear();
    _electronics.clear();

    for (var master in mastersList) {
      if (master.isMaster) {
        _kanafMasters.add(master);
      } else if (master.isPainter) {
        _painters.add(master);
      } else if (master.isLightLine) {
        _lightLines.add(master);
      } else if (master.isElectric) {
        _electronics.add(master);
      }
    }
  }

  Future<List<Master>?> getMastersList(
      {required int pageKey, MasterServices? type, int? cityId}) async {
    List<Master>? result;

    String queryParam = '';
    if (type != null) {
      if (type == MasterServices.kanafWorker) {
        queryParam += '/?is_master=true';
      } else if (type == MasterServices.lightLineWorker) {
        queryParam += '/?is_light_line=true';
      } else if (type == MasterServices.painterWorker) {
        queryParam += '/?is_painter=true';
      } else if (type == MasterServices.electronicWorker) {
        queryParam += '/?is_electric=true';
      }
    }

    if (cityId != null) {
      if (queryParam.isEmpty) {
        queryParam = '/?';
      } else {
        queryParam += '&';
      }

      queryParam += 'city=$cityId';
    }

    await ApiController.instance.request(
      url: "master/profiles$queryParam",
      method: ApiMethod.get,
      onSuccess: (response) {
        result = [];
        for (var item in response.data['results']) {
          result!.add(Master.fromJson(item));
        }
        fillMastersList(result!);
      },
      onCatchDioError: (e) {
        _apiMessage = e.response?.data["detail"] ?? "";
      },
      onCatchError: (e) {
        _apiMessage = "مشکلی پیش امده است";
      },
    );

    return result;
  }

  Future<bool> getMasterOrEmployer({
    required int id,
  }) async {
    bool result = false;

    await ApiController.instance.request(
      url: "master/profiles/$id",
      method: ApiMethod.get,
      needAuth: false,
      onSuccess: (response) {
        _master = Master.fromJson(response.data);
        result = true;
      },
      onCatchDioError: (e) {
        _apiMessage = e.response?.data["detail"] ?? "";
      },
      onCatchError: (e) {
        _apiMessage = "مشکلی پیش امده است";
      },
    );

    return result;
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
        onSuccess: (response) {
          result = true;
        },
        onCatchDioError: (e) {
          _apiMessage = e.response?.data["detail"] ?? "";
        },
        onCatchError: (e) {
          _apiMessage = "مشکلی پیش امده است";
        });

    return result;
  }

  Future<bool> deleteMaster(int id) async {
    bool result = false;

    await ApiController.instance.request(
        url: "master/profile/$id/",
        method: ApiMethod.delete,
        onSuccess: (response) {
          result = true;
        },
        onCatchDioError: (e) {
          _apiMessage = e.response?.data["detail"] ?? "";
        },
        onCatchError: (e) {
          _apiMessage = "مشکلی پیش امده است";
        });

    return result;
  }
}
