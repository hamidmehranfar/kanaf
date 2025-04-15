import 'package:kanaf/models/city.dart';
import 'package:kanaf/models/post_item.dart';
import 'package:kanaf/models/user.dart';

import '../res/enums/project_type.dart';

class EmployerProject {
  int id;
  List<PostItem> items;
  int likeCount;
  User profile;
  int? currentUserLike;
  DateTime createdTime;
  String caption;
  bool isPriceAgreed;
  num? price;
  int duration;
  int area;
  int? view;
  City? city;

  EmployerProject({
    required this.id,
    required this.items,
    required this.likeCount,
    required this.profile,
    required this.currentUserLike,
    required this.createdTime,
    required this.caption,
    required this.isPriceAgreed,
    required this.price,
    required this.duration,
    required this.area,
    required this.view,
    required this.city,
  });

  EmployerProject.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        items = json["items"]
            .map<PostItem>((item) => PostItem.fromJson(item))
            .toList(),
        likeCount = json["like_count"],
        profile = User.fromJson(json['profile']),
        currentUserLike = json["current_user_like"],
        createdTime = DateTime.tryParse(json['created_time']) ?? DateTime.now(),
        caption = json["caption"],
        isPriceAgreed = json["is_price_agreed"],
        price = json['price'],
        duration = json["duration"],
        area = json['area'],
        view = json["view"],
        city = City.fromJson(json["city"]);
}
