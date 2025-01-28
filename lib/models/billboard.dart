class BillBoard{
  int id;
  String url;
  String link;

  BillBoard({required this.id, required this.url,
    required this.link});

  BillBoard.fromJson(Map<String, dynamic> json) :
    id = json["id"],
    url = json["image"],
    link = json["link"];
}