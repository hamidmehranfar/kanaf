import 'package:get/get.dart';

import '/models/calculate_material.dart';
import '/controllers/api_controller.dart';
import '/models/main_category.dart';
import '/res/enums/api_method.dart';

class CalculateController extends GetxController {
  String _apiMessage = "";

  List<MainCategory> _mainCategories = [];

  String get apiMessage => _apiMessage;

  List<MainCategory> get mainCategories => _mainCategories;

  Future<bool> getSubCategory() async {
    bool result = false;

    await ApiController.instance.request(
      url: "material/categories/",
      method: ApiMethod.get,
      onSuccess: (response) {
        _mainCategories.clear();
        for (var value in response.data) {
          _mainCategories.add(MainCategory.fromJson(value));
        }

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

  Future<(List<(String, String)>?, CalculateMaterial?)> getResult({
    required int mainCategoryId,
    required String quantity,
    required String variable1Value,
    required String variable2Value,
    String? variable1Label,
    String? variable2Label,
  }) async {
    List<(String, String)>? results;
    CalculateMaterial? material;

    Map<String, String> payload = {
      "material_type_id": mainCategoryId.toString() ?? '',
      "quantity": quantity,
    };

    if (variable1Label != null && variable1Value.isNotEmpty) {
      payload["variable1_name"] = variable1Label;
      payload["variable1_value"] = variable1Value;
    }
    if (variable2Label != null && variable2Value.isNotEmpty) {
      payload["variable2_name"] = variable2Label;
      payload["variable2_value"] = variable2Value;
    }

    await ApiController.instance.request(
      url: "material/calculations/",
      method: ApiMethod.post,
      data: payload,
      onSuccess: (response) {
        results = [];
        material = CalculateMaterial.fromJson(response.data["material_type"]);
        response.data["result"].forEach((key, value) {
          results!.add((key, value));
        });
      },
      onCatchDioError: (e) {
        _apiMessage = e.response?.data["detail"] ?? "";
      },
      onCatchError: (e) {
        _apiMessage = "مشکلی پیش امده است";
      },
    );

    return (results, material);
  }
}
