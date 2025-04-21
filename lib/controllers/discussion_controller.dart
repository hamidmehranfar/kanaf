import 'package:get/get.dart';
import 'package:kanaf/controllers/api_controller.dart';
import 'package:kanaf/models/discussion_category.dart';
import 'package:kanaf/res/enums/api_method.dart';

class DiscussionController extends GetxController {
  String _apiMessage = "";

  String get apiMessage => _apiMessage;

  Future<List<DiscussionCategory>?> getCategories() async {
    List<DiscussionCategory>? result;

    await ApiController.instance.request(
      url: "forum/categories/",
      method: ApiMethod.get,
      onSuccess: (response) {
        result = [];
        for (var value in response.data) {
          result?.add(DiscussionCategory.fromJson(value));
        }
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
}
