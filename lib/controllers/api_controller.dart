import 'package:dio/dio.dart';
import 'package:get/get.dart' as g;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '/controllers/authentication_controller.dart';
import '/res/controllers_key.dart';
import '/res/enums/api_method.dart';


class ApiController{
  late Dio _dio;
  final String _baseUrl = "https://server2.webravo.ir/api/v1/";

  ApiController._singleton() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(milliseconds: 40000),
        receiveTimeout: const Duration(milliseconds: 40000),
        sendTimeout: const Duration(milliseconds: 40000),
      ),
    );

    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: false,
      ),
    );
  }

  static final ApiController instance = ApiController._singleton();

  Future<void> request({
    required String url,
    required ApiMethod method,
    var data,
    required void Function(Response response) onSuccess,
    required void Function(DioException error) onCatchDioError,
    required void Function(Exception error) onCatchError,
    bool needAuth = true,
    Options? options,
    bool isMultipleFiles = false,
    })async {
    Response? response;

    if(needAuth){
      AuthenticationController authController = g.Get.find(
        tag: ControllersKey.authControllerKey
      );
      options = Options(
        headers: {
          //FIXME : fix here
          "Authorization" : "Token 1210724a9a057abc24c24f675392eba9d1139465",
        },
        contentType: isMultipleFiles ? 'multipart/form-data' : null,
      );
    }

    String fullUrl = "$_baseUrl$url";

    try{
      switch(method){
        case ApiMethod.get:
          response = await _dio.get(
            fullUrl,
            data: data,
            options: options,
          );
          break;
        case ApiMethod.post:
          response = await _dio.post(
            fullUrl,
            data: data,
            options: options,
          );
          break;
        case ApiMethod.put:
          response = await _dio.put(
            fullUrl,
            data: data,
            options: options,
          );
          break;
        case ApiMethod.delete:
          response = await _dio.delete(
            fullUrl,
            data: data,
            options: options,
          );
          break;
        case ApiMethod.patch:
          response = await _dio.patch(
            fullUrl,
            data: data,
            options: options,
          );
          break;
      }
      onSuccess(response);
    }
    on DioException catch(e){
      onCatchDioError(e);
    }
    on Exception catch(e){
      onCatchError(e);
    }
  }
}