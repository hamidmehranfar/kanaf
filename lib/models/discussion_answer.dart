import 'package:kanaf/models/reaction.dart';
import 'package:kanaf/models/user.dart';

class DiscussionAnswer {
  int id;
  User user;
  DateTime? createdTime;
  int discussionId;
  String answer;
  List<DiscussionAnswer> repliedAnswers;
  num repliedAnswerCount;
  num likeCount;
  num dislikeCount;
  Reaction? currentUserReaction;

  DiscussionAnswer(
    this.id,
    this.user,
    this.createdTime,
    this.discussionId,
    this.answer,
    this.repliedAnswers,
    this.repliedAnswerCount,
    this.likeCount,
    this.dislikeCount,
    this.currentUserReaction,
  );

  DiscussionAnswer.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        user = User.fromJson(json["user"]),
        createdTime = DateTime.tryParse(json["created_time"]),
        discussionId = json["discussion"],
        answer = json["answer"],
        repliedAnswers = json["replied_answers"] == null
            ? []
            : json["replied_answers"]
                .map<DiscussionAnswer>(
                    (item) => DiscussionAnswer.fromJson(item))
                .toList(),
        repliedAnswerCount = json["replied_answer_count"],
        likeCount = json["like_count"] ?? 0,
        dislikeCount = json["dislike_count"] ?? 0,
        currentUserReaction = json["current_user_reaction"] == null
            ? null
            : Reaction.fromJson(json["current_user_reaction"]);
}
