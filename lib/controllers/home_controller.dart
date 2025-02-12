import '/controllers/api_controller.dart';
import '/models/billboard.dart';
import '/models/comment.dart';
import '/res/enums/api_method.dart';

class HomeController{
  String? _apiMessage;

  String? get apiMessage => _apiMessage;

  Future<List<BillBoard>> fetchImages() async {
    List<BillBoard> result = [];
    await ApiController.instance.request(
      url: "home/billboards/",
      method: ApiMethod.get,
      onSuccess: (response){
        for(int i=0;i<response.data["results"].length;i++){
          result.add(BillBoard.fromJson(response.data["results"][i]));
        }
      },
      onCatchDioError: (error){
        _apiMessage = error.response?.data["detail"];
      },
      onCatchError: (error){
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
      onSuccess: (response){
        comments = [];
        for(var item in response.data["results"]){
          comments?.add(Comment.fromJson(item));
        }
        print(response.data["results"]);
      },
      onCatchDioError: (error){
        _apiMessage = error.response?.data["detail"];
      },
      onCatchError: (error){
        _apiMessage = "مشکلی پیش امده است";
      },
    );

    return comments;
  }
}