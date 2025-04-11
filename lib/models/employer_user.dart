import '/models/city.dart';
import '/models/user.dart';
import '/res/enums/degree_type.dart';
import '/res/enums/payment_type.dart';

class EmployerUser {
  final int id;
  final User user;
  final City city;
  final String title;
  final String bio;
  final String birthday;
  final PaymentType paymentType;
  final DegreeType degreeType;

  EmployerUser(
    this.id,
    this.user,
    this.city,
    this.title,
    this.bio,
    this.birthday,
    this.paymentType,
    this.degreeType,
  );

  EmployerUser.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        user = User.fromJson(json["user"]),
        city = City.fromJson(json["city"]),
        title = json["title"],
        bio = json["bio"],
        birthday = json["birthday"],
        paymentType = convertStringToPayment(json["payment"]),
        degreeType = convertStringToDegree(json["degree"]);
}
