import 'dart:io';

import 'package:get/get.dart';

import 'package:dio/dio.dart' as dio;
import '/controllers/api_controller.dart';
import '/models/project.dart';
import '/res/enums/api_method.dart';

class ProjectController extends GetxController{
  String _apiMessage = '';

  get apiMessage {
    return _apiMessage;
  }

  Future<List<Project>?> getProjects(int pageKey) async {
    List<Project>? projects;

    await ApiController.instance.request(
      url: "master/projects/?kind=sent&pageKey=$pageKey",
      method: ApiMethod.get,
      onSuccess: (response){
        projects = [];
        for(var item in response.data["results"]){
          projects!.add(Project.fromJson(item));
        }
      },
      onCatchDioError: (e){
        _apiMessage = e.response?.data['detail'] ?? '';
      },
      onCatchError: (e){
        _apiMessage = 'مشکلی پیش آمده است';
      }
    );

    return projects;
  }

  Future<bool> createProject({
    required String area,
    required String description,
    required String address,
    required String city,
    File? image,
  }) async {
    bool result = false;

    // dio.FormData formData = dio.FormData();
    //
    // formData.fields.add(MapEntry('area', area));
    // formData.fields.add(MapEntry('address', address));
    // formData.fields.add(MapEntry('city', city));
    //
    // if(description !=null) {
    //   formData.fields.add(
    //     MapEntry('description', description)
    //   );
    // }

    await ApiController.instance.request(
        url: "master/projects/",
        method: ApiMethod.post,
        data: {
          'area' : area,
          'address': address,
          'description' : description,
          // 'city' : city,
          'city': '2',
        },
        onSuccess: (response){
          result = true;
        },
        onCatchDioError: (e){
          _apiMessage = e.response?.data['detail'] ?? '';
        },
        onCatchError: (e){
          _apiMessage = 'مشکلی پیش آمده است';
        }
    );

    return result;
  }

  Future<Project?> updateProject(int projectId) async {
    Project? project;

    await ApiController.instance.request(
        url: "master/projects/$projectId/",
        method: ApiMethod.patch,
        onSuccess: (response){
          project = Project.fromJson(response.data);
        },
        onCatchDioError: (e){
          _apiMessage = e.response?.data['detail'] ?? '';
        },
        onCatchError: (e){
          _apiMessage = 'مشکلی پیش آمده است';
        }
    );

    return project;
  }

  Future<void> deleteProject(int projectId) async {
    await ApiController.instance.request(
        url: "master/projects/$projectId/",
        method: ApiMethod.delete,
        onSuccess: (response){
          _apiMessage = "پروژه با موفقیت حذف شد";
        },
        onCatchDioError: (e){
          _apiMessage = e.response?.data['detail'] ?? '';
        },
        onCatchError: (e){
          _apiMessage = 'مشکلی پیش آمده است';
        }
    );
  }
}