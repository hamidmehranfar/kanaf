import 'dart:io';

import 'package:get/get.dart';

import 'package:dio/dio.dart' as dio;
import '../res/enums/media_type.dart';
import '/controllers/api_controller.dart';
import '/models/project.dart';
import '/res/enums/api_method.dart';

class ProjectController extends GetxController {
  String _apiMessage = '';

  List<(File?, MediaType?)> _images = List.generate(6, (index) => (null, null));

  List<bool> _picturesLoading = List.generate(6, (index) => false);

  List<(File?, MediaType?)> get images => _images;

  List<bool> get picturesLoading => _picturesLoading;

  get apiMessage {
    return _apiMessage;
  }

  void initPostValues() {
    _images = List.generate(6, (index) => (null, null));
    _picturesLoading = List.generate(6, (index) => false);
  }

  Future<List<Project>?> getProjects(int pageKey) async {
    List<Project>? projects;

    await ApiController.instance.request(
        url: "master/projects/?kind=sent&pageKey=$pageKey",
        method: ApiMethod.get,
        onSuccess: (response) {
          projects = [];
          for (var item in response.data["results"]) {
            projects!.add(Project.fromJson(item));
          }
        },
        onCatchDioError: (e) {
          _apiMessage = e.response?.data['detail'] ?? '';
        },
        onCatchError: (e) {
          _apiMessage = 'مشکلی پیش آمده است';
        });

    return projects;
  }

  Future<List<Project>?> getEmployerProjects() async {
    List<Project>? projects;

    await ApiController.instance.request(
      url: "master/projects/?kind=sent",
      method: ApiMethod.get,
      onSuccess: (response) {
        projects = [];
        for (var item in response.data["results"]) {
          projects!.add(Project.fromJson(item));
        }
      },
      onCatchDioError: (e) {
        _apiMessage = e.response?.data['detail'] ?? '';
      },
      onCatchError: (e) {
        _apiMessage = 'مشکلی پیش آمده است';
      },
    );

    return projects;
  }

  Future<bool> createProject({
    required String area,
    required String description,
    required String address,
    required int cityId,
    required int profileId,
    required List<(File?, MediaType?)> posts,
    File? image,
  }) async {
    bool result = false;

    List<(File, MediaType)> selectedImages = [];
    for (var image in posts) {
      if (image.$1 != null && image.$2 != null) {
        selectedImages.add((image.$1!, image.$2!));
      }
    }

    dio.FormData formData = dio.FormData.fromMap({
      'area': area,
      'address': address,
      'description': description,
      'city': cityId,
      "profile": profileId,
    });

    for (int i = 0; i < selectedImages.length; i++) {
      formData.fields.add(MapEntry("items[$i]item_type",
          selectedImages[i].$2 == MediaType.image ? '0' : '1'));
      formData.files.add(
        MapEntry(
          "items[$i]file",
          await dio.MultipartFile.fromFile(selectedImages[i].$1.path,
              filename: selectedImages[i].$1.path.split('/').last),
        ),
      );
    }

    await ApiController.instance.request(
        url: "master/projects/",
        method: ApiMethod.post,
        data: formData,
        onSuccess: (response) {
          result = true;
        },
        onCatchDioError: (e) {
          _apiMessage = e.response?.data['detail'] ?? '';
        },
        onCatchError: (e) {
          _apiMessage = 'مشکلی پیش آمده است';
        });

    return result;
  }

  Future<Project?> updateProject(int projectId) async {
    Project? project;

    await ApiController.instance.request(
        url: "master/projects/$projectId/",
        method: ApiMethod.patch,
        onSuccess: (response) {
          project = Project.fromJson(response.data);
        },
        onCatchDioError: (e) {
          _apiMessage = e.response?.data['detail'] ?? '';
        },
        onCatchError: (e) {
          _apiMessage = 'مشکلی پیش آمده است';
        });

    return project;
  }

  Future<void> deleteProject(int projectId) async {
    await ApiController.instance.request(
      url: "master/projects/$projectId/",
      method: ApiMethod.delete,
      onSuccess: (response) {
        _apiMessage = "پروژه با موفقیت حذف شد";
      },
      onCatchDioError: (e) {
        _apiMessage = e.response?.data['detail'] ?? '';
      },
      onCatchError: (e) {
        _apiMessage = 'مشکلی پیش آمده است';
      },
    );
  }
}
