import 'package:kanaf/res/enums/calculate_type.dart';

import 'calculate_material.dart';

class SubCategory {
  final int id;
  final String image;
  final String name;
  final List<CalculateMaterial> materials;

  SubCategory(this.id, this.name, this.image, this.materials);

  SubCategory.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        image = json["image"],
        materials = List.from(json["material_types"]
            .map((item) => CalculateMaterial.fromJson(item)));
}
