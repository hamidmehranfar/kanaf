import 'package:kanaf/models/sub_category.dart';

import '../res/enums/calculate_type.dart';

class MainCategory {
  final int id;
  final String name;
  final bool isComingSoon;
  final List<SubCategory> subCategories;

  MainCategory(
    this.id,
    this.name,
    this.subCategories,
    this.isComingSoon,
  );

  MainCategory.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        isComingSoon = json["is_comming_soon"],
        subCategories = List.from(
          json["subcategories"].map(
            (item) => SubCategory.fromJson(item),
          ),
        );
}
