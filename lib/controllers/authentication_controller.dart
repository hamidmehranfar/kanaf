import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/controllers/api_controller.dart';
import '/models/employer_user.dart';
import '/models/user.dart';
import '/res/enums/api_method.dart';
import '/res/enums/introduction_type.dart';
import '/res/enums/master_request_types.dart';
import '/res/shared_preference_keys.dart';

class AuthenticationController extends GetxController {
  User? _user;

  String? _userToken;

  String? _apiMessage;

  User? get user => _user;

  String? get userToken => _userToken;

  String? get apiMessage => _apiMessage;

  set userToken(String? token) => _userToken = token;

  Future<(bool, bool)> login(String phone) async {
    bool result = false;
    bool isSuccess = false;

    await ApiController.instance.request(
      url: "accounts/login/",
      method: ApiMethod.post,
      data: {
        "username": phone,
      },
      needAuth: false,
      onSuccess: (response) {
        result = response.data["registered"] ?? false;
        isSuccess = true;
        _apiMessage = response.data["detail"];
      },
      onCatchDioError: (error) {
        _apiMessage = error.response?.data is Map
            ? error.response?.data["detail"]
            : "مشکلی پیش امده است";
      },
      onCatchError: (error) {
        _apiMessage = "مشکلی پیش امده است";
      },
    );

    return (result, isSuccess);
  }

  Future<bool> verifyOtp({
    required String username,
    required String otp,
    required bool isSignUp,
    String? firstName,
    String? lastName,
    String? email,
    String? job,
    IntroductionType? type,
    int? selectedAvatar,
    String? avatar,
  }) async {
    dio.FormData formData = dio.FormData.fromMap({
      "username": username,
      "otp": otp,
    });

    if (isSignUp) {
      if (firstName != null && firstName != '') {
        formData.fields.add(
          MapEntry("first_name", firstName),
        );
      }
      if (lastName != null && lastName != '') {
        formData.fields.add(
          MapEntry("last_name", lastName),
        );
      }
      if (email != null && email != '') {
        formData.fields.add(
          MapEntry("email", email),
        );
      }
      if (job != null && job != '') {
        formData.fields.add(
          MapEntry("job", job),
        );
      }
      if (type != null) {
        formData.fields.add(
          MapEntry("introduction", convertIntroductionToIndex(type).toString()),
        );
      }
      if (selectedAvatar != null) {
        formData.fields.add(
          MapEntry("selected_avatar", selectedAvatar.toString()),
        );
      } else if (avatar != null) {
        formData.files.add(
          MapEntry(
            "avatar",
            await dio.MultipartFile.fromFile(avatar,
                filename: avatar.split('/').last),
          ),
        );
      }
    }

    bool result = false;
    await ApiController.instance.request(
      url: "accounts/verify-otp/",
      method: ApiMethod.post,
      needAuth: false,
      data: formData,
      onSuccess: (response) async {
        _userToken = response.data["token"];
        saveToken();
        result = true;
      },
      onCatchDioError: (error) {
        _apiMessage = error.response?.data["detail"];
      },
      onCatchError: (error) {
        _apiMessage = "مشکلی پیش امده است";
      },
    );

    return result;
  }

  Future<bool> getUser() async {
    bool result = false;

    await ApiController.instance.request(
      url: "accounts/user/",
      options: dio.Options(
        headers: {"Authorization": "Token $_userToken"},
      ),
      method: ApiMethod.get,
      needAuth: false,
      onSuccess: (response) {
        _user = User.fromJson(response.data);
        _user?.token = _userToken;
        result = true;
      },
      onCatchDioError: (error) {
        _apiMessage = error.response?.data["detail"];
      },
      onCatchError: (error) {
        _apiMessage = "مشکلی پیش امده است";
      },
    );

    return result;
  }

  Future<(MasterRequestTypes?, String?)> getMasterStatus() async {
    MasterRequestTypes? type;
    String? text;

    await ApiController.instance.request(
      url: 'master/request/',
      method: ApiMethod.get,
      onSuccess: (response) {
        type = convertStringToMasterType(
          response.data["state"]["display"],
        );
        text = response.data["abort_reason"];
      },
      onCatchDioError: (error) {
        _apiMessage = error.response?.data["detail"];
      },
      onCatchError: (error) {
        _apiMessage = "مشکلی پیش امده است";
      },
    );

    return (type, text);
  }

  Future<bool> activateMasterProfile({
    required File nationalCardImage,
    required File jobImage,
    required int cityId,
    required bool isMaster,
    required bool isLightLine,
    required bool isPainter,
    required bool isElectronic,
  }) async {
    bool result = false;

    dio.FormData formData = dio.FormData.fromMap({
      'city': cityId,
      'is_master': isMaster,
      'is_painter': isPainter,
      'is_light_line': isLightLine,
      'is_electric': isElectronic,
    });

    formData.files.add(
      MapEntry(
        "activation_job",
        await dio.MultipartFile.fromFile(jobImage.path,
            filename: jobImage.path.split('/').last),
      ),
    );
    formData.files.add(
      MapEntry(
        "activation_national_card",
        await dio.MultipartFile.fromFile(nationalCardImage.path,
            filename: nationalCardImage.path.split('/').last),
      ),
    );

    await ApiController.instance.request(
      url: "master/request/",
      method: ApiMethod.post,
      data: formData,
      onSuccess: (response) {
        _apiMessage = response.data["detail"];
        result = true;
      },
      onCatchDioError: (error) {
        _apiMessage = error.response?.data["detail"];
      },
      onCatchError: (error) {
        _apiMessage = "مشکلی پیش امده است";
      },
    );

    return result;
  }

  Future<bool> activateEmployerProfile({
    required String title,
    required int cityId,
    required String bio,
    required String birthDate,
    required int paymentIndex,
    required int degreeIndex,
    required ApiMethod method,
  }) async {
    bool result = false;

    await ApiController.instance.request(
      url:
          "employer/profiles/${method == ApiMethod.patch ? '${_user?.employerProfileId}/' : ''}",
      method: method,
      data: {
        'title': title,
        'city': cityId,
        'bio': bio,
        'payment': paymentIndex,
        'degree': degreeIndex,
        'birthday': birthDate.toString(),
      },
      onSuccess: (response) {
        _apiMessage = response.data["detail"];
        result = true;
      },
      onCatchDioError: (error) {
        if (error.response?.data is Map) {
          _apiMessage = error.response?.data["detail"];
        }
      },
      onCatchError: (error) {
        _apiMessage = "مشکلی پیش امده است";
      },
    );

    return result;
  }

  Future<EmployerUser?> getEmployerProfile() async {
    EmployerUser? result;

    await ApiController.instance.request(
      url: "employer/profiles/${user?.employerProfileId}",
      method: ApiMethod.get,
      onSuccess: (response) {
        result = EmployerUser.fromJson(response.data);
      },
      onCatchDioError: (error) {
        _apiMessage = error.response?.data["detail"];
      },
      onCatchError: (error) {
        _apiMessage = "مشکلی پیش امده است";
      },
    );
    return result;
  }

  Future<void> saveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(SharedPreferenceKeys.savedToken, _userToken ?? '');
  }

  Future<void> getSavedToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.containsKey(SharedPreferenceKeys.savedToken)) {
      _userToken = pref.getString(SharedPreferenceKeys.savedToken);
    }
  }

  Future<void> removeSavedToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove(SharedPreferenceKeys.savedToken);
  }
}
