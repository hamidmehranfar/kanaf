import '/models/tutorial.dart';
import '/controllers/api_controller.dart';
import '/models/billboard.dart';
import '/models/home_comment.dart';
import '/res/enums/api_method.dart';

class HomeController {
  String? _apiMessage;

  String? get apiMessage => _apiMessage;

  Future<List<BillBoard>?> fetchImages() async {
    List<BillBoard>? result;
    await ApiController.instance.request(
      url: "home/billboards/",
      method: ApiMethod.get,
      onSuccess: (response) {
        result = [];
        for (int i = 0; i < response.data["results"].length; i++) {
          result!.add(BillBoard.fromJson(response.data["results"][i]));
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

  Future<List<HomeComment>?> fetchComments() async {
    List<HomeComment>? comments;
    await ApiController.instance.request(
      url: "home/reviews/",
      method: ApiMethod.get,
      onSuccess: (response) {
        comments = [];
        for (var item in response.data["results"]) {
          comments?.add(HomeComment.fromJson(item));
        }
      },
      onCatchDioError: (error) {
        _apiMessage = error.response?.data["detail"];
      },
      onCatchError: (error) {
        _apiMessage = "مشکلی پیش امده است";
      },
    );

    return comments;
  }

  Future<String?> getTips() async {
    String? result;
    await ApiController.instance.request(
      url: 'home/tips/',
      method: ApiMethod.get,
      onSuccess: (response) {
        result = "";
        for (var value in response.data['results']) {
          result = result! + value["text"];
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

  Future<List<Tutorial>?> getTutorials(int pageKey) async {
    List<Tutorial>? tutorials;
    await ApiController.instance.request(
      url: 'home/tutorials?page=$pageKey',
      method: ApiMethod.get,
      onSuccess: (response) {
        tutorials = [];
        print(response.data);
        for (var result in response.data["results"]) {
          tutorials?.add(Tutorial.fromJson(result));
        }
      },
      onCatchDioError: (error) {
        _apiMessage = error.response?.data["detail"];
      },
      onCatchError: (error) {
        _apiMessage = "مشکلی پیش امده است";
      },
    );

    return tutorials;
  }
}
