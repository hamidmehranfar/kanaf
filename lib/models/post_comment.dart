import '/models/user.dart';

class PostComment{
  int id;
  int post;
  User user;
  String comment;

  PostComment(this.id, this.post, this.user, this.comment);

  PostComment.fromJson(Map<String, dynamic> json) :
    id = json["id"],
    post = json["post"],
    user = User.fromJson(json["user"]),
    comment = json["comment"];
}