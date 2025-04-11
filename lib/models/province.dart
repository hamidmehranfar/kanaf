import 'package:kanaf/models/city.dart';

class Province {
  int id;
  String name;
  List<City> cities;

  Province({
    required this.id,
    required this.name,
    required this.cities,
  });

  Province.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        cities = List.from(
          json["cities"].map(
            (item) => City.fromJson(item),
          ),
        );
}
