class CalculateMaterial {
  final int id;
  final String name;
  final String image;
  final String description;
  final String? variableName1;
  final String? variableLabel1;
  final String? variableName2;
  final String? variableLabel2;

  CalculateMaterial(
    this.id,
    this.name,
    this.image,
    this.description,
    this.variableName1,
    this.variableLabel1,
    this.variableName2,
    this.variableLabel2,
  );

  CalculateMaterial.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        image = json["image"],
        description = json["description"],
        variableName1 = json["variable1_name"],
        variableLabel1 = json["variable1_verbose_name"],
        variableName2 = json["variable2_name"],
        variableLabel2 = json["variable2_verbose_name"];
}
