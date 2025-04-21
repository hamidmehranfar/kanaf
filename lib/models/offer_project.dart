import '/models/project_state.dart';
import '/models/user.dart';
import '/res/enums/project_type.dart';

class OfferProject {
  int id;
  User masterProfile;
  ProjectType kind;
  DateTime? createdTime;
  DateTime? endedTime;
  ProjectState state;
  num? rating;
  num price;
  num duration;
  String message;
  int postId;

  OfferProject(
    this.id,
    this.masterProfile,
    this.kind,
    this.createdTime,
    this.endedTime,
    this.state,
    this.rating,
    this.price,
    this.duration,
    this.message,
    this.postId,
  );

  OfferProject.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        masterProfile = User.fromJson(json["master_profile"]["user"]),
        kind = convertToProjectType(json["kind"]),
        createdTime = DateTime.tryParse(json["created_time"]),
        endedTime = json["ended_time"] == null
            ? null
            : DateTime.tryParse(json["ended_time"]),
        state = ProjectState.fromJson(json["state"]),
        rating = json["rating"] != null ? num.tryParse(json["rating"]) : null,
        price = json["price"],
        duration = json["duration"],
        message = json["message"],
        postId = json["post"];
}
