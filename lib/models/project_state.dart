class ProjectState {
  String value;
  String display;

  ProjectState({
    required this.value,
    required this.display,
  });

  ProjectState.fromJson(Map<String, dynamic> json)
      : value = json["value"],
        display = json["display"];
}
