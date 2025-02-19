import 'package:kanaf/models/address.dart';
import 'package:kanaf/models/user.dart';

import '../res/enums/project_type.dart';

class Project{
  int id;
  ProjectType type;
  User user;
  DateTime createdTime;
  DateTime? endedTime;
  String state;
  num? price;
  num area;
  String userAddress;
  num? rating;
  String? description;
  User? profileUser;
  int? profileUserId;
  Address? address;

  Project({
    required this.id,
    required this.type,
    required this.user,
    required this.createdTime,
    required this.endedTime,
    required this.state,
    required this.price,
    required this.area,
    required this.userAddress,
    this.rating,
    this.description,
    this.profileUser,
    this.profileUserId,
    this.address,
  });

  Project.fromJson(Map<String, dynamic> json):
    id = json['id'],
    type = convertToProjectType(json['kind']),
    user = User.fromJson(json['user']),
    createdTime = DateTime.tryParse(json['created_time']) ?? DateTime.now(),
    endedTime = DateTime.tryParse(json['ended_time'] ?? ''),
    state = json['state']['display'],
    price = json['price'],
    area = json['area'],
    userAddress = json['address'],
    rating = json['rating'],
    description = json['description'],
    profileUserId = json['profile'] == null ? null
        : json['profile']['id'],
    profileUser = json['profile'] == null ? null
        : User.fromJson(json['profile']['user']),
    address = Address.fromJson(json['city']);
}