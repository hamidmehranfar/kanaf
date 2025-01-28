import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:kanaf/controllers/api_controller.dart';
import 'package:kanaf/models/user.dart';
import 'package:kanaf/res/enums/api_method.dart';

class AuthenticationController extends GetxController{
  User? _user;

  String? _apiMessage;

  User? get user => _user;

  String? get apiMessage => _apiMessage;

  Future<bool> login(String phone) async {
    bool result = false;

    await ApiController.instance.request(
      url: "accounts/login/",
      method: ApiMethod.post,
      data: {
        "username": phone,
      },
      needAuth: false,
      onSuccess: (response){
        _apiMessage = response.data["detail"];
        result = true;
      },
      onCatchDioError: (error){
        _apiMessage = error.response?.data[""];
      },
      onCatchError: (error){
        _apiMessage = "مشکلی پیش امده است";
      },
    );

    return result;
  }

  Future<bool> verifyOtp(String username, String otp) async {
    String? token;
    await ApiController.instance.request(
      url: "accounts/verify-otp/",
      method: ApiMethod.post,
      needAuth: false,
      data: {
        "username": username,
        "otp": otp
      },
      onSuccess: (response) async {
        token = response.data["token"];
      },
      onCatchDioError: (error){
        _apiMessage = error.response?.data[""];
      },
      onCatchError: (error){
        _apiMessage = "مشکلی پیش امده است";
      },
    );

    if(token != null){
      return await getUser(token!);
    }

    return false;
  }

  Future<bool> getUser(String token) async {
    bool result = false;

    await ApiController.instance.request(
      url: "accounts/user/",
      options: Options(headers: {
        "Authorization" : "Token $token"
      }),
      method: ApiMethod.get,
      needAuth: false,  
      onSuccess: (response){
        _user = User.fromJson(response.data["data"]);
        _user?.token = token;
        result = true;
      },
      onCatchDioError: (error){
        _apiMessage = error.response?.data[""];
      },
      onCatchError: (error){
        _apiMessage = "مشکلی پیش امده است";
      },
    );

    return result;
  }
}