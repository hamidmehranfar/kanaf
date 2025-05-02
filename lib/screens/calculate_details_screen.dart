import 'package:flutter/material.dart';

import '/models/main_category.dart';
import '/global_configs.dart';
import '/res/app_colors.dart';
import '/widgets/calculate_item.dart';
import '/widgets/my_divider.dart';
import '/widgets/custom_appbar.dart';

class CalculateDetailsScreen extends StatelessWidget {
  final MainCategory mainCategory;

  const CalculateDetailsScreen({
    super.key,
    required this.mainCategory,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppbar(
        onTap: () {
          Navigator.of(context).pop();
        },
        iconAsset: "assets/icons/arrow_back_19.png",
      ),
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: globalPadding * 6,
          child: Column(
            children: [
              const SizedBox(height: 15),
              Text(
                mainCategory.name,
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w300,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: globalPadding * 5,
                child: MyDivider(
                  color: theme.colorScheme.onSecondary,
                  height: 1,
                  thickness: 1,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: globalBorderRadius * 6,
                  ),
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return Padding(
                        padding: globalPadding * 6,
                        child: MyDivider(
                          color: AppColors.textFieldColor,
                          height: 2,
                          thickness: 2,
                        ),
                      );
                    },
                    itemCount: mainCategory.subCategories.length ?? 0,
                    itemBuilder: (context, index) {
                      return CalculateItem(
                        subCategory: mainCategory.subCategories[index],
                      );
                    },
                    shrinkWrap: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
