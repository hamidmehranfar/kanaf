import 'discussion_category.dart';
import 'user.dart';
import 'reaction.dart';

class Discussion {
  int id;
  User user;
  DateTime? createdTime;
  String? image;
  DiscussionCategory category;
  String title;
  String text;
  num answerCount;
  num likeCount;
  num dislikeCount;
  Reaction? currentUserReaction;

  Discussion(
    this.id,
    this.user,
    this.createdTime,
    this.image,
    this.category,
    this.title,
    this.text,
    this.answerCount,
    this.likeCount,
    this.dislikeCount,
    this.currentUserReaction,
  );

  Discussion.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        user = User.fromJson(json["user"]),
        createdTime = DateTime.tryParse(json["created_time"]) ?? null,
        image = json["image"],
        category = DiscussionCategory.fromJson(json["category"]),
        title = json["title"],
        text = json["text"],
        likeCount = json["like_count"] ?? 0,
        dislikeCount = json["dislike_count"] ?? 0,
        answerCount = json["answer_count"] ?? 0,
        currentUserReaction = json["current_user_reaction"] == null
            ? null
            : Reaction.fromJson(json["current_user_reaction"]);
}
