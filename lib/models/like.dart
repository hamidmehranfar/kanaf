import '/models/user.dart';

class Like{
  int id;
  User user;
  int post;

  Like(this.id, this.user, this.post);

  Like.fromJson(Map<String, dynamic> json) :
    id = json["id"],
    user = User.fromJson(json["user"]),
    post = json["post"];
}