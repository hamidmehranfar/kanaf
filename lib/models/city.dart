class City {
  int id;
  String name;

  City({required this.id, required this.name});

  City.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];
}
