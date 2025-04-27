import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/controllers/calculate_controller.dart';
import '/global_configs.dart';
import '/res/app_colors.dart';
import '/res/controllers_key.dart';
import '/res/enums/calculate_type.dart';
import '/widgets/calculate_item.dart';
import '/widgets/custom_shimmer.dart';
import '/widgets/my_divider.dart';
import '/widgets/custom_appbar.dart';
import '/widgets/custom_error_widget.dart';

class CalculateDetailsScreen extends StatefulWidget {
  final CalculateType type;

  const CalculateDetailsScreen({
    super.key,
    required this.type,
  });

  @override
  State<CalculateDetailsScreen> createState() => _CalculateDetailsScreenState();
}

class _CalculateDetailsScreenState extends State<CalculateDetailsScreen> {
  bool isLoading = true;
  bool isFailed = false;

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
      isFailed = false;
    });

    await calculateController.getSubCategory(widget.type).then((result) {
      if (!result) {
        isFailed = true;
      }
    });

    setState(() {
      isLoading = false;
    });
  }

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
                "کناف ${convertCalculateTypeToString(widget.type)}",
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
              if (isLoading)
                CustomShimmer(
                  child: Column(
                    children: [
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: globalBorderRadius * 5,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                )
              else if (isFailed)
                Center(
                  child: CustomErrorWidget(
                    onTap: () async {
                      await fetchMaterials();
                    },
                  ),
                )
              else
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
                      itemCount: calculateController
                              .mainCategory?.subCategories.length ??
                          0,
                      itemBuilder: (context, index) {
                        return CalculateItem(
                          subCategory: calculateController
                              .mainCategory!.subCategories[index],
                        );
                      },
                      shrinkWrap: true,
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
