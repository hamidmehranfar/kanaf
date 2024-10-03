import 'package:kanaf/models/comment.dart';

class HomeController{
  Future<List<String>> fetchImages() async {
    await Future.delayed(Duration(seconds: 2));
    return ["","","","",""];
  }

  Future<List<Comment>> fetchComments() async {
    await Future.delayed(Duration(seconds: 2));
    return [
      Comment(name: "حمید", comment: "اقا عباس کناف کار خیلی خوبه ."),
      Comment(name: "حمید", comment: "اقا عباس کناف کار خیلی خوبه ."),
      Comment(name: "حمید", comment: "اقا عباس کناف کار خیلی خوبه ."),
      Comment(name: "حمید", comment: "اقا عباس کناف کار خیلی خوبه ."),
    ];
  }
}