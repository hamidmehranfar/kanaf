class Comment {
  int id;
  String name;
  String? position;
  String? text;
  String? imageUrl;

  Comment(this.id, this.name, this.position, this.text, this.imageUrl);

  Comment.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        position = json["position"],
        text = json["text"],
        imageUrl = json["image"];
}
