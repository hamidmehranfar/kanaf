import 'dart:io';

import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kanaf/res/enums/offer_status.dart';

import '/models/employer_project.dart';
import '/models/offer_project.dart';
import '/res/enums/project_type.dart';
import '/res/enums/media_type.dart';
import '/controllers/api_controller.dart';
import '/res/enums/api_method.dart';

class ProjectController extends GetxController {
  String _apiMessage = '';

  List<PagingController<int, OfferProject>> _offerTabPagingController = [];

  get apiMessage {
    return _apiMessage;
  }

  // Future<List<Project>?> getProjects(int pageKey) async {
  //   List<Project>? projects;
  //
  //   await ApiController.instance.request(
  //       url: "master/projects/?kind=sent&pageKey=$pageKey",
  //       method: ApiMethod.get,
  //       onSuccess: (response) {
  //         projects = [];
  //         for (var item in response.data["results"]) {
  //           projects!.add(Project.fromJson(item));
  //         }
  //       },
  //       onCatchDioError: (e) {
  //         _apiMessage = e.response?.data['detail'] ?? '';
  //       },
  //       onCatchError: (e) {
  //         _apiMessage = 'مشکلی پیش آمده است';
  //       });
  //
  //   return projects;
  // }

  List<PagingController<int, OfferProject>> get offerTabPagingController =>
      _offerTabPagingController;

  void initPagingControllers() {
    _offerTabPagingController = List.generate(
      OfferStatus.values.length,
      (index) {
        return PagingController(firstPageKey: 1);
      },
    );
  }

  void deposePagingControllers() {
    for (var controller in _offerTabPagingController) {
      controller.dispose();
    }
  }

  Future<List<EmployerProject>?> getHomeProjects(int pageKey) async {
    List<EmployerProject>? projects;

    await ApiController.instance.request(
      url: "employer/posts/?pageKey=$pageKey",
      method: ApiMethod.get,
      onSuccess: (response) {
        projects = [];
        for (var item in response.data["results"]) {
          projects!.add(EmployerProject.fromJson(item));
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

  Future<List<EmployerProject>?> getEmployerProjects() async {
    List<EmployerProject>? projects;

    await ApiController.instance.request(
      url: "employer/posts/",
      method: ApiMethod.get,
      onSuccess: (response) {
        projects = [];
        for (var item in response.data["results"]) {
          projects!.add(EmployerProject.fromJson(item));
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

  Future<bool> createProjectWithMaster({
    required String area,
    required String description,
    required String address,
    required int cityId,
    required int profileId,
    required List<(File?, MediaType?)> posts,
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
      },
    );

    return result;
  }

  Future<bool> createProjectForEmployer({
    required String caption,
    required bool isPriceAgreed,
    required String price,
    required String duration,
    required String area,
    required int cityId,
    required List<(File?, MediaType?)> posts,
  }) async {
    bool result = false;

    List<(File, MediaType)> selectedImages = [];
    for (var image in posts) {
      if (image.$1 != null && image.$2 != null) {
        selectedImages.add((image.$1!, image.$2!));
      }
    }

    dio.FormData formData = dio.FormData.fromMap({
      'caption': caption,
      'area': area,
      'is_price_agreed': isPriceAgreed,
      'price': price,
      'duration': duration,
      'city': cityId,
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
      url: "employer/posts/",
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
      },
    );

    return result;
  }

  Future<bool> editEmployerProject({
    required Map data,
    required int projectId,
  }) async {
    bool result = false;

    await ApiController.instance.request(
      url: "employer/posts/$projectId/",
      method: ApiMethod.patch,
      data: data,
      onSuccess: (response) {
        result = true;
      },
      onCatchDioError: (e) {
        _apiMessage = e.response?.data['detail'] ?? '';
      },
      onCatchError: (e) {
        _apiMessage = 'مشکلی پیش آمده است';
      },
    );

    return result;
  }

  Future<bool> deleteEmployerProject({
    required int projectId,
  }) async {
    bool result = false;

    await ApiController.instance.request(
      url: "employer/posts/$projectId/",
      method: ApiMethod.delete,
      onSuccess: (response) {
        result = true;
      },
      onCatchDioError: (e) {
        _apiMessage = e.response?.data['detail'] ?? '';
      },
      onCatchError: (e) {
        _apiMessage = 'مشکلی پیش آمده است';
      },
    );

    return result;
  }

  Future<bool> offerProject(
    int projectId,
    String description,
    String duration,
    String price,
  ) async {
    bool result = false;

    await ApiController.instance.request(
      url: "employer/proposals/",
      method: ApiMethod.post,
      data: {
        "post": projectId,
        "message": description,
        "duration": duration,
        "price": price,
      },
      onSuccess: (response) {
        result = true;
      },
      onCatchDioError: (e) {
        _apiMessage = e.response?.data['detail'] ?? '';
      },
      onCatchError: (e) {
        _apiMessage = 'مشکلی پیش آمده است';
      },
    );

    return result;
  }

  Future<List<OfferProject>?> getOffers({
    required ProjectType type,
    required int pageKey,
    required int? status,
  }) async {
    List<OfferProject>? projects;

    String queryParam = "?kind=${type.name}&pageKey=$pageKey";
    if (status != null) {
      queryParam += "&state=$status";
    }

    await ApiController.instance.request(
      url: "employer/proposals/$queryParam",
      method: ApiMethod.get,
      onSuccess: (response) {
        projects = [];
        for (var item in response.data["results"]) {
          projects!.add(OfferProject.fromJson(item));
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

  Future<bool> changeOfferState({
    required int id,
    required OfferStatus status,
    int? rating,
  }) async {
    bool result = false;

    Map data = {
      "state": convertOfferStatusToIndex(status),
    };

    if (rating != null) {
      data["rating"] = rating;
    }

    await ApiController.instance.request(
      url: "employer/proposals/$id/",
      method: ApiMethod.patch,
      data: data,
      onSuccess: (response) {
        result = true;
      },
      onCatchDioError: (e) {
        _apiMessage = e.response?.data['detail'] ?? '';
      },
      onCatchError: (e) {
        _apiMessage = 'مشکلی پیش آمده است';
      },
    );

    return result;
  }

  Future<bool> changeOfferValues({
    required int id,
    required Map data,
  }) async {
    bool result = false;

    await ApiController.instance.request(
      url: "employer/proposals/$id/",
      method: ApiMethod.patch,
      data: data,
      onSuccess: (response) {
        result = true;
      },
      onCatchDioError: (e) {
        _apiMessage = e.response?.data['detail'] ?? '';
      },
      onCatchError: (e) {
        _apiMessage = 'مشکلی پیش آمده است';
      },
    );

    return result;
  }
}
