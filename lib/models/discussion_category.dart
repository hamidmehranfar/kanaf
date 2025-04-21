class DiscussionCategory {
  int id;
  String name;
  String description;
  int discussionCount;

  DiscussionCategory(
      this.id, this.name, this.description, this.discussionCount);

  DiscussionCategory.fromJson(Map<String, dynamic> items)
      : id = items["id"],
        name = items["name"],
        description = items["description"],
        discussionCount = items["discussion_count"];
}
