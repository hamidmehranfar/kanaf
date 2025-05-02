import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/controllers/calculate_controller.dart';
import '/global_configs.dart';
import '/res/controllers_key.dart';
import '/widgets/choose_item_image.dart';
import '/widgets/custom_shimmer.dart';
import '/res/app_colors.dart';
import '/screens/calculate_details_screen.dart';
import '../my_divider.dart';

class ChooseCalculationTypeDialog extends StatefulWidget {
  const ChooseCalculationTypeDialog({super.key});

  @override
  State<ChooseCalculationTypeDialog> createState() =>
      _ChooseCalculationTypeDialogState();
}

class _ChooseCalculationTypeDialogState
    extends State<ChooseCalculationTypeDialog> {
  bool isLoading = true;

  CalculateController calculateController = Get.find(
    tag: ControllersKey.calculateControllerKey,
  );

  @override
  void initState() {
    super.initState();

    fetchMaterials();
  }

  Future<void> fetchMaterials() async {
    setState(() {
      isLoading = true;
    });

    await calculateController.getSubCategory();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Dialog(
      backgroundColor: theme.colorScheme.primary,
      child: ListView(
        padding: globalPadding * 5,
        shrinkWrap: true,
        children: [
          const SizedBox(height: 33),
          Text(
            "محاسبه",
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w300,
              color: theme.colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 33),
          MyDivider(
            color: AppColors.paleBlack,
            height: 1,
            thickness: 1,
          ),
          const SizedBox(height: 35),
          Wrap(
            spacing: 20,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: List.generate(
              isLoading ? 4 : calculateController.mainCategories.length,
              (index) {
                if (isLoading) {
                  return CustomShimmer(
                    child: Container(
                      width: 120,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: globalBorderRadius * 2,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  );
                }
                return Opacity(
                  opacity:
                      calculateController.mainCategories[index].isComingSoon
                          ? 0.5
                          : 1,
                  child: ChooseItemImage(
                    onTap: () {
                      if (calculateController
                          .mainCategories[index].isComingSoon) {
                        return;
                      }
                      Get.off(
                        CalculateDetailsScreen(
                          mainCategory:
                              calculateController.mainCategories[index],
                        ),
                      );
                    },
                    text: calculateController.mainCategories[index].name,
                    textStyle: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                    width: 120,
                    height: 50,
                    color: theme.colorScheme.tertiary,
                    topPadding: 0,
                    bottomPadding: 10,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 33),
          MyDivider(
            color: AppColors.paleBlack,
            height: 1,
            thickness: 1,
          ),
          const SizedBox(height: 25),
          ChooseItemImage(
            onTap: () {
              if (!isLoading) {}
            },
            text: "تاریخچه محاسبات",
            textStyle: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            width: 180,
            height: 60,
            color: theme.colorScheme.secondary,
            topPadding: 0,
            bottomPadding: 10,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
