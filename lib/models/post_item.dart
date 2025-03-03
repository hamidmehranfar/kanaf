import '/res/enums/media_type.dart';

class PostItem {
  int id;
  MediaType itemType;
  String file;

  PostItem(this.id, this.itemType, this.file);

  PostItem.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        itemType = convertToMediaType(json["item_type"]),
        file = json["file"];
}
