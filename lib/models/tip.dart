class Tip {
  String title;
  String image;
  String description;

  Tip(this.title, this.image, this.description);

  Tip.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        image = json['image'],
        description = json['description'];
}
