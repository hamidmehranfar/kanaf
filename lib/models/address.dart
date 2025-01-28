class Address{
  int id;
  String name;

  Address({required this.id, required this.name});

  Address.fromJson(Map<String, dynamic> json):
    id = json['id'],
    name = json['name'];
}