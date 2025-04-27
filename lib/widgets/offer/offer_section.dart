import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:kanaf/res/enums/message_type.dart';

import '../error_snack_bar.dart';
import '/models/offer_project.dart';
import '/controllers/project_controller.dart';
import '/global_configs.dart';
import '/res/app_colors.dart';
import '/res/controllers_key.dart';
import '/widgets/my_divider.dart';
import '../button_item.dart';

class OfferSection extends StatefulWidget {
  final int projectId;
  final OfferProject? offeredProject;

  const OfferSection({
    super.key,
    required this.projectId,
    this.offeredProject,
  });

  @override
  State<OfferSection> createState() => _OfferSectionState();
}

class _OfferSectionState extends State<OfferSection> {
  TextEditingController durationTextController = TextEditingController();
  TextEditingController priceTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();

  ProjectController projectController = Get.find(
    tag: ControllersKey.projectControllerKey,
  );

  bool offerLoading = false;

  Future<void> offerProject() async {
    if (durationTextController.text.isEmpty ||
        priceTextController.text.isEmpty) {
      showSnackbarMessage(
        context: context,
        message: "مقادیر را وارد کنید",
      );
      return;
    }

    setState(() {
      offerLoading = true;
    });

    await projectController
        .offerProject(
      widget.projectId,
      descriptionTextController.text,
      durationTextController.text,
      priceTextController.text,
    )
        .then(
      (value) {
        if (!value) {
          showSnackbarMessage(
            context: context,
            message: projectController.apiMessage,
          );
        } else {
          showSnackbarMessage(
            context: context,
            message: "پیشنهاد ارسال شد",
            type: MessageType.success,
          );
          Get.close(2);
        }
      },
    );

    setState(() {
      offerLoading = false;
    });
  }

  Future<void> changeOffer() async {
    Map data = {};

    if (descriptionTextController.text != widget.offeredProject?.message) {
      data["message"] = descriptionTextController.text;
    }

    if (priceTextController.text != widget.offeredProject?.price.toString()) {
      data["price"] = priceTextController.text;
    }

    if (durationTextController.text !=
        widget.offeredProject?.duration.toString()) {
      data["duration"] = durationTextController.text;
    }

    if (data.isEmpty) {
      return;
    }

    setState(() {
      offerLoading = true;
    });

    await projectController
        .changeOfferValues(
      id: widget.projectId,
      data: data,
    )
        .then(
      (value) {
        if (!value) {
          showSnackbarMessage(
            context: context,
            message: projectController.apiMessage,
          );
        } else {
          showSnackbarMessage(
            context: context,
            message: "پیشنهاد تغییر داده شد",
            type: MessageType.success,
          );
          Get.back(result: true);
        }
      },
    );

    setState(() {
      offerLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.offeredProject != null) {
      durationTextController.text = widget.offeredProject!.duration.toString();
      priceTextController.text = widget.offeredProject!.price.toString();
      descriptionTextController.text = widget.offeredProject!.message;
    }
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
            "فرم پیشنهاد به کارفرما",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w400,
              color: theme.colorScheme.surface.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 25),
          MyDivider(
            color: AppColors.paleBlack,
            height: 1,
            thickness: 1,
          ),
          const SizedBox(height: 23),
          Container(
            margin: globalPadding * 5,
            padding: const EdgeInsets.only(bottom: 5, right: 9, left: 9),
            decoration: BoxDecoration(
              color: AppColors.textFieldColor,
              borderRadius: globalBorderRadius * 4,
            ),
            child: TextField(
              controller: priceTextController,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.surface,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                hintText: "قیمت پیشنهادی (تومان)",
                hintStyle: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.surface.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            margin: globalPadding * 5,
            padding: const EdgeInsets.only(bottom: 5, right: 9, left: 9),
            decoration: BoxDecoration(
              color: AppColors.textFieldColor,
              borderRadius: globalBorderRadius * 4,
            ),
            child: TextField(
              controller: durationTextController,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.surface,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                hintText: "مدت زمان پیشنهادی (روز)",
                hintStyle: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.surface.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            margin: globalPadding * 5,
            padding: const EdgeInsets.only(bottom: 5, right: 9, left: 9),
            decoration: BoxDecoration(
              color: AppColors.textFieldColor,
              borderRadius: globalBorderRadius * 4,
            ),
            child: TextField(
              controller: descriptionTextController,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.surface,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                hintText: "توضیحات",
                hintStyle: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.surface.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          MyDivider(
            color: AppColors.paleBlack,
            height: 1,
            thickness: 1,
          ),
          const SizedBox(height: 14),
          offerLoading
              ? SpinKitThreeBounce(
                  size: 14,
                  color: theme.colorScheme.tertiary,
                )
              : ButtonItem(
                  width: 200,
                  height: 50,
                  onTap: () async {
                    if (widget.offeredProject == null) {
                      await offerProject();
                    } else {
                      await changeOffer();
                    }
                  },
                  title:
                      widget.offeredProject != null ? "تغییر پیشنهاد" : "ارسال",
                  isButtonDisable: offerLoading,
                  color: theme.colorScheme.tertiary,
                  textStyle: theme.textTheme.bodyLarge,
                ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
