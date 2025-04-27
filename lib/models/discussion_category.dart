class DiscussionCategory {
  int id;
  String name;
  String description;
  String image;
  int discussionCount;

  DiscussionCategory(
    this.id,
    this.name,
    this.description,
    this.discussionCount,
    this.image,
  );

  DiscussionCategory.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        description = json["description"],
        image = json["image"],
        discussionCount = json["discussion_count"];
}
