import 'package:get/get.dart';

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

  Future<Project?> createProject({
    required String area,
    String? description,
    required String address,
    required String city,
  }) async {
    Project? project;

    await ApiController.instance.request(
        url: "master/projects/",
        method: ApiMethod.post,
        data: {
          "area": area,
          "description": description,
          "address": address,
          "city": city,
        },
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