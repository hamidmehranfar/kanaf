import '/res/enums/introduction_type.dart';

class User {
  int? id;
  String? token;
  String? userName;
  String? firstName;
  String? lastName;
  String? email;
  String? job;
  IntroductionType? introduction;
  String? avatar;
  String? selectedDefaultAvatar;
  int? masterProfileId;
  int? employerProfileId;

  User({
    this.token,
    this.userName,
    this.firstName,
    this.lastName,
    this.email,
    this.job,
    this.introduction,
    this.avatar,
    this.selectedDefaultAvatar,
    this.masterProfileId,
    this.employerProfileId,
  });

  User.fromJson(Map<String, dynamic> json) {
    firstName = json["first_name"];
    lastName = json["last_name"];
    userName = json["username"];
    email = json["email"];
    job = json["job"];
    avatar = json["avatar"];
    selectedDefaultAvatar = json["selected_avatar"];
    introduction = convertToIntroductionType(json["type"]);
    masterProfileId = json["master_profile_id"];
    employerProfileId = json["employer_profile_id"];
  }
}
