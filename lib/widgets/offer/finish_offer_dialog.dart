import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:kanaf/res/enums/message_type.dart';

import '../error_snack_bar.dart';
import '/global_configs.dart';
import '/controllers/project_controller.dart';
import '/res/controllers_key.dart';
import '/res/enums/offer_status.dart';
import '../button_item.dart';

class FinishOfferDialog extends StatefulWidget {
  final int projectId;

  const FinishOfferDialog({
    super.key,
    required this.projectId,
  });

  @override
  State<FinishOfferDialog> createState() => _FinishOfferDialogState();
}

class _FinishOfferDialogState extends State<FinishOfferDialog> {
  int? rating;
  bool isRatingLoading = false;

  ProjectController projectController = Get.find(
    tag: ControllersKey.projectControllerKey,
  );

  Future<void> finishOffer() async {
    if (rating == null) {
      showSnackbarMessage(
        context: context,
        message: "امتیاز را وارد کنید",
      );
      return;
    }
    setState(() {
      isRatingLoading = true;
    });

    await projectController
        .changeOfferState(
      id: widget.projectId,
      status: OfferStatus.finish,
      rating: rating,
    )
        .then((value) {
      if (!value) {
        showSnackbarMessage(
          context: context,
          message: projectController.apiMessage,
        );
      } else {
        showSnackbarMessage(
          context: context,
          message: "امتیاز با موفقیت ثبت شد",
          type: MessageType.success,
        );
        Get.back(result: true);
      }
    });

    setState(() {
      isRatingLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Dialog(
      backgroundColor: theme.colorScheme.primary,
      child: ListView(
        padding: globalPadding * 4,
        shrinkWrap: true,
        children: [
          const SizedBox(height: 25),
          Text(
            "امتیاز به استادکار",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w400,
              color: theme.colorScheme.surface.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              5,
              (int index) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      rating = 4 - index;
                    });
                  },
                  icon: Icon(
                    rating == null || rating! < (4 - index)
                        ? Icons.star_border
                        : Icons.star,
                    size: 32,
                    color: theme.colorScheme.secondary,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          isRatingLoading
              ? SpinKitThreeBounce(
                  size: 14,
                  color: theme.colorScheme.tertiary,
                )
              : ButtonItem(
                  width: 200,
                  height: 50,
                  onTap: () async {
                    await finishOffer();
                  },
                  title: "خاتمه پروژه",
                  isButtonDisable: isRatingLoading,
                  color: theme.colorScheme.tertiary,
                  textStyle: theme.textTheme.bodyLarge,
                ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
