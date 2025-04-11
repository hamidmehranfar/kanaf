import 'package:kanaf/models/sub_category.dart';

import '../res/enums/calculate_type.dart';

class MainCategory {
  final int id;
  final CalculateType type;
  final List<SubCategory> subCategories;

  MainCategory(this.id, this.type, this.subCategories);

  MainCategory.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        type = convertStringToCalculateType(json["name"]),
        subCategories = List.from(
            json["subcategories"].map((item) => SubCategory.fromJson(item)));
}
