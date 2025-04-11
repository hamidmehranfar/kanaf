import 'package:flutter/material.dart';
import 'package:kanaf/global_configs.dart';
import 'package:kanaf/models/sub_category.dart';
import 'package:kanaf/widgets/calculate_info_dialog.dart';
import 'package:kanaf/widgets/custom_cached_image.dart';

class CalculateItem extends StatelessWidget {
  final SubCategory subCategory;

  const CalculateItem({
    super.key,
    required this.subCategory,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: globalPadding * 4,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.end,
                  children: List.generate(
                    subCategory.materials.length,
                    (int index) {
                      return InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CalculateInfoDialog(
                                material: subCategory.materials[index],
                              );
                            },
                          ).then((value) async {});
                        },
                        child: Container(
                          width: 90,
                          height: 35,
                          padding: globalPadding / 2,
                          decoration: BoxDecoration(
                            borderRadius: globalBorderRadius * 3,
                            color: theme.colorScheme.tertiary
                                .withValues(alpha: 0.75),
                          ),
                          child: Center(
                            child: Text(
                              subCategory.materials[index].name,
                              style: theme.textTheme.labelSmall,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: globalBorderRadius * 3,
                    child: CustomCachedImage(
                      url: subCategory.image,
                      width: 115,
                      height: 72,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 115,
                    child: Center(
                      child: Text(
                        subCategory.name,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
