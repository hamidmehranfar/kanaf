class PostItem{
  int id;
  String itemType;
  String file;

  PostItem(this.id, this.itemType, this.file);

  PostItem.fromJson(Map<String, dynamic> json):
    id = json["id"],
    itemType = json["item_type"],
    file = json["file"];
}