class HomeComment {
  int id;
  String name;
  String? position;
  String? text;
  String? imageUrl;

  HomeComment(this.id, this.name, this.position, this.text, this.imageUrl);

  HomeComment.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        position = json["position"],
        text = json["text"],
        imageUrl = json["image"];
}
