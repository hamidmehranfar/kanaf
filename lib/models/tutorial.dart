class Tutorial {
  int id;
  String? createdTime;
  String url;
  String? slug;
  String title;
  String image;
  String body;
  int? view;

  Tutorial(
    this.id,
    this.createdTime,
    this.url,
    this.slug,
    this.title,
    this.image,
    this.body,
    this.view,
  );

  Tutorial.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        createdTime = json['created_time'],
        url = json["url"],
        slug = json['slug'],
        title = json['title'],
        image = json['image'],
        body = json['body'],
        view = json['views'];
}
