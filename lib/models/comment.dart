class Comment{
  int id;
  String name;
  String position;

  Comment(this.id , this.name, this.position);

  Comment.fromJson(Map<String, dynamic> json) :
    id = json["id"],
    name = json["name"],
    position = json["position"];
}