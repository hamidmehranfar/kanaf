import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanaf/controllers/post_controller.dart';
import 'package:kanaf/res/controllers_key.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '/widgets/offer/offer_section.dart';
import '/widgets/post/display_media_section.dart';
import '/controllers/size_controller.dart';
import '/global_configs.dart';
import '/models/employer_project.dart';
import '/res/app_colors.dart';
import '/widgets/my_divider.dart';
import '/widgets/button_item.dart';
import '/widgets/custom_appbar.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final EmployerProject project;

  const ProjectDetailsScreen({
    super.key,
    required this.project,
  });

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  PostController postController = Get.find(
    tag: ControllersKey.postControllerKey,
  );

  @override
  void initState() {
    super.initState();

    postController.videoControllers.clear();
    postController.videoControllers.add(({}, 0, true));
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppbar(
        onTap: () {
          Navigator.pop(context);
        },
        iconAsset: "assets/icons/arrow_back_19.png",
      ),
      body: SizedBox(
        height: SizeController.height(context),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 25),
              Text(
                "جزئیات پروژه",
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w300,
                  color: theme.colorScheme.tertiary,
                ),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: globalPadding * 11,
                child: MyDivider(
                  color: AppColors.paleBlack,
                  height: 1,
                  thickness: 1,
                ),
              ),
              const SizedBox(height: 13),
              Container(
                margin: globalPadding * 6,
                padding: globalPadding * 7,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: globalBorderRadius * 6,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 28),
                    DisplayMediaSection(
                      items: widget.project.items,
                      radius: 25,
                      index: 0,
                    ),
                    const SizedBox(height: 25),
                    Container(
                      margin: globalPadding * 3,
                      padding: globalPadding * 5.5,
                      decoration: BoxDecoration(
                        borderRadius: globalBorderRadius * 4,
                        color:
                            theme.colorScheme.primary.withValues(alpha: 0.32),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "کپشن",
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.secondary
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  widget.project.caption,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: theme.colorScheme.secondary
                                        .withValues(alpha: 0.5),
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "قیمت توافقی",
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.secondary
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                              Text(
                                widget.project.isPriceAgreed ? "دارد" : "ندارد",
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.secondary
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "قیمت",
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.secondary
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "${widget.project.price.toString().toPersianDigit().seRagham()} تومان",
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: theme.colorScheme.secondary
                                        .withValues(alpha: 0.5),
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "مدت زمان پیشنهادی",
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.secondary
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "${widget.project.duration.toString().toPersianDigit().seRagham()} روز",
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: theme.colorScheme.secondary
                                        .withValues(alpha: 0.5),
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "متراژ حدودی",
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.secondary
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "${widget.project.area.toString().toPersianDigit().seRagham()} روز",
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: theme.colorScheme.secondary
                                        .withValues(alpha: 0.5),
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "شهر",
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.secondary
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  widget.project.city?.name ?? '',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: theme.colorScheme.secondary
                                        .withValues(alpha: 0.5),
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: globalPadding * 11,
                child: MyDivider(
                  color: AppColors.paleBlack,
                  height: 1,
                  thickness: 1,
                ),
              ),
              const SizedBox(height: 10),
              ButtonItem(
                width: 200,
                height: 50,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return OfferSection(
                        projectId: widget.project.id,
                      );
                    },
                  );
                },
                title: "ارائه پیشنهاد",
                color: theme.colorScheme.tertiary,
                textStyle: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
