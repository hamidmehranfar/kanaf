import '/models/tip.dart';
import '/controllers/api_controller.dart';
import '/models/billboard.dart';
import '/models/comment.dart';
import '/res/enums/api_method.dart';

class HomeController {
  String? _apiMessage;

  String? get apiMessage => _apiMessage;

  Future<List<BillBoard>> fetchImages() async {
    List<BillBoard> result = [];
    await ApiController.instance.request(
      url: "home/billboards/",
      method: ApiMethod.get,
      onSuccess: (response) {
        for (int i = 0; i < response.data["results"].length; i++) {
          result.add(BillBoard.fromJson(response.data["results"][i]));
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

  Future<List<Comment>?> fetchComments() async {
    List<Comment>? comments;
    await ApiController.instance.request(
      url: "home/reviews/",
      method: ApiMethod.get,
      onSuccess: (response) {
        comments = [];
        for (var item in response.data["results"]) {
          comments?.add(Comment.fromJson(item));
        }
        print(response.data["results"]);
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

  Future<List<Tip>?> getTips(int pageKey) async {
    List<Tip>? tips;
    await ApiController.instance.request(
      url: 'home/tips/?pageKey=$pageKey',
      method: ApiMethod.get,
      onSuccess: (response) {
        tips = [];
        for (var item in response.data['results']) {
          tips!.add(Tip.fromJson(item));
        }
      },
      onCatchDioError: (error) {
        _apiMessage = error.response?.data["detail"];
      },
      onCatchError: (error) {
        _apiMessage = "مشکلی پیش امده است";
      },
    );

    return tips;
  }
}
