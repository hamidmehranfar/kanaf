import 'package:kanaf/models/address.dart';
import 'package:kanaf/models/user.dart';

class Master{
  int id;
  User user;
  Address city;
  bool isMaster;
  bool isPainter;
  bool isLightLine;
  bool isElectric;
  String bio;
  DateTime birthDate;
  int? workExperience;
  int? workHourStart;
  int? workHourEnd;
  String payment;
  String degree;

  Master({
    required this.id,
    required this.user,
    required this.city,
    required this.isMaster,
    required this.isPainter,
    required this.isLightLine,
    required this.isElectric,
    required this.bio,
    required this.birthDate,
    required this.workExperience,
    required this.workHourStart,
    required this.workHourEnd,
    required this.payment,
    required this.degree
  });

  factory Master.fromJson(Map<String, dynamic> json) => Master(
    id: json["id"],
    user: User.fromJson(json["user"]),
    city: Address.fromJson(json["city"]),
    isMaster: json["is_master"],
    isPainter: json["is_painter"],
    isLightLine: json["is_light_line"],
    isElectric: json["is_electric"],
    bio: json["bio"],
    birthDate: DateTime.tryParse(json["birthday"]) ?? DateTime.now(),
    workExperience: json["work_experience"],
    workHourStart: json["work_hours_start"],
    workHourEnd: json["works_hours_end"],
    payment: json["payment"],
    degree: json["degree"]
  );
}