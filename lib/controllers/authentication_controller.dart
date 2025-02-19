import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanaf/controllers/api_controller.dart';
import 'package:kanaf/models/user.dart';
import 'package:kanaf/res/enums/api_method.dart';
import 'package:kanaf/res/enums/introduction_type.dart';

class AuthenticationController extends GetxController{
  User? _user;

  String? _apiMessage;

  User? get user => _user;

  String? get apiMessage => _apiMessage;

  Future<(bool,bool)> login(String phone) async {
    bool result = false;
    bool isSuccess = false;

    await ApiController.instance.request(
      url: "accounts/login/",
      method: ApiMethod.post,
      data: {
        "username": phone,
      },
      needAuth: false,
      onSuccess: (response){
        result = response.data["registered"] ?? false;
        isSuccess = true;
        _apiMessage = response.data["detail"];
      },
      onCatchDioError: (error){
        _apiMessage = error.response?.data[""];
      },
      onCatchError: (error){
        _apiMessage = "مشکلی پیش امده است";
      },
    );

    return (result, isSuccess);
  }

  Future<String?> verifyOtp({
    required String username, required String otp,
    required bool isSignUp, String? firstName,
    String? lastName, String? email, String? job,
    IntroductionType? type,
  }) async {
    Map data = {
      "username": username,
      "otp": otp
    };

    if(isSignUp){
      if(firstName != null && firstName != ''){
        data['first_name'] = firstName;
      }
      if(lastName != null && lastName != ''){
        data['last_name'] = lastName;
      }
      if(email != null && email != ''){
        data['email'] = email;
      }
      if(job != null && job != ''){
        data['job'] = job;
      }
      if(type != null){
        data['introduction'] = convertIntroductionToIndex(type).toString();
      }
    }

    String? token;
    await ApiController.instance.request(
      url: "accounts/verify-otp/",
      method: ApiMethod.post,
      needAuth: false,
      data: data,
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

    return token;
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
        _user = User.fromJson(response.data);
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