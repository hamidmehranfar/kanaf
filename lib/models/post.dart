import '/models/post_item.dart';
import '/models/user.dart';

class Post {
  int id;
  List<PostItem> items;
  int likeCount;
  int commentCount;
  int profileId;
  User user;
  DateTime createdDate;
  String caption;
  bool? isCurrentUserLiked;

  Post(
    this.id,
    this.items,
    this.likeCount,
    this.commentCount,
    this.profileId,
    this.user,
    this.createdDate,
    this.caption,
    this.isCurrentUserLiked,
  );

  Post.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        items = json["items"] == null
            ? []
            : json["items"]
                .map<PostItem>((item) => PostItem.fromJson(item))
                .toList(),
        likeCount = json["like_count"],
        commentCount = json["comment_count"],
        profileId = json["profile"]["id"],
        user = User.fromJson(json["profile"]["user"]),
        createdDate = DateTime.tryParse(json["created_time"]) ?? DateTime.now(),
        caption = json["caption"],
        isCurrentUserLiked = json["current_user_like"] == null ? false : true;
}
