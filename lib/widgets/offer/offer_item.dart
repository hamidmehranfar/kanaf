import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:kanaf/res/app_colors.dart';
import 'package:kanaf/widgets/offer/finish_offer_dialog.dart';

import '/res/enums/offer_status.dart';
import '/res/enums/project_type.dart';
import '/controllers/project_controller.dart';
import '/res/controllers_key.dart';
import '/models/offer_project.dart';
import '/widgets/custom_cached_image.dart';
import '/global_configs.dart';
import 'offer_section.dart';

class OfferItem extends StatefulWidget {
  final OfferProject offer;
  final ProjectType type;
  final Function() onTap;

  const OfferItem({
    super.key,
    required this.type,
    required this.offer,
    required this.onTap,
  });

  @override
  State<OfferItem> createState() => _OfferItemState();
}

class _OfferItemState extends State<OfferItem> {
  bool isAcceptOfferLoading = false;
  bool isDenyOfferLoading = false;

  ProjectController projectController = Get.find(
    tag: ControllersKey.projectControllerKey,
  );

  Future<void> acceptOffer() async {
    setState(() {
      isAcceptOfferLoading = true;
    });

    await projectController
        .changeOfferState(
      id: widget.offer.id,
      status: OfferStatus.accept,
    )
        .then(
      (value) {
        //show success
      },
    );

    setState(() {
      isAcceptOfferLoading = false;
    });
  }

  Future<void> denyOffer() async {
    setState(() {
      isDenyOfferLoading = true;
    });

    await projectController
        .changeOfferState(
      id: widget.offer.id,
      status: OfferStatus.deny,
    )
        .then(
      (value) {
        //show success
      },
    );

    setState(() {
      isDenyOfferLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return SizedBox(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${widget.offer.masterProfile.firstName ?? ''} ${widget.offer.masterProfile.lastName ?? ''}",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.surface,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        widget.offer.message,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontSize: 8,
                          color: theme.colorScheme.surface,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "زمان : ${widget.offer.duration}",
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.tertiary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          "مبلغ : ${widget.offer.price}",
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.tertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 11),
              Column(
                children: [
                  Container(
                    padding: globalAllPadding / 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.surface,
                    ),
                    child: ClipOval(
                      child: CustomCachedImage(
                        url: widget.offer.masterProfile.avatar ?? '',
                        width: 60,
                        height: 60,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: 70,
                    padding: globalPadding,
                    decoration: BoxDecoration(
                      borderRadius: globalBorderRadius,
                      color: AppColors.sideColor,
                    ),
                    child: Text(
                      widget.offer.state.display,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontSize: 9,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          widget.type == ProjectType.received
              ? widget.offer.state.state == OfferStatus.accept
                  ? SizedBox(
                      height: 24,
                      child: FilledButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return FinishOfferDialog(
                                projectId: widget.offer.id,
                              );
                            },
                          ).then((value) {
                            if (value != null && value is bool && value) {
                              widget.onTap();
                            }
                          });
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: theme.colorScheme.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: globalBorderRadius * 3,
                          ),
                          padding: globalPadding * 2,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          "خاتمه",
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontSize: 9,
                          ),
                        ),
                      ),
                    )
                  : widget.offer.state.state != OfferStatus.review
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 24,
                              child: isAcceptOfferLoading
                                  ? SpinKitThreeBounce(
                                      size: 16,
                                      color: theme.colorScheme.onPrimary,
                                    )
                                  : FilledButton(
                                      onPressed: () async {
                                        await acceptOffer();
                                        widget.onTap();
                                      },
                                      style: FilledButton.styleFrom(
                                        backgroundColor:
                                            theme.colorScheme.secondary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: globalBorderRadius * 3,
                                        ),
                                        padding: globalPadding * 2,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(
                                        "تایید پیشنهاد",
                                        style: theme.textTheme.labelMedium
                                            ?.copyWith(
                                          fontSize: 9,
                                        ),
                                      ),
                                    ),
                            ),
                            const SizedBox(width: 16),
                            SizedBox(
                              height: 24,
                              child: isDenyOfferLoading
                                  ? SpinKitThreeBounce(
                                      size: 16,
                                      color: theme.colorScheme.onPrimary,
                                    )
                                  : FilledButton(
                                      onPressed: () async {
                                        await denyOffer();
                                        widget.onTap();
                                      },
                                      style: FilledButton.styleFrom(
                                        backgroundColor:
                                            theme.colorScheme.secondary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: globalBorderRadius * 3,
                                        ),
                                        padding: globalPadding * 2,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(
                                        "رد پیشنهاد",
                                        style: theme.textTheme.labelMedium
                                            ?.copyWith(
                                          fontSize: 9,
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        )
              : widget.offer.state.state == OfferStatus.deny ||
                      widget.offer.state.state == OfferStatus.review
                  ? SizedBox(
                      height: 24,
                      child: FilledButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return OfferSection(
                                projectId: widget.offer.id,
                                offeredProject: widget.offer,
                              );
                            },
                          ).then((value) {
                            if (value != null && value is bool && value) {
                              widget.onTap();
                            }
                          });
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: theme.colorScheme.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: globalBorderRadius * 3,
                          ),
                          padding: globalPadding * 2,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          "تغییر پیشنهاد",
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontSize: 9,
                          ),
                        ),
                      ),
                    )
                  : Container(),
        ],
      ),
    );
  }
}
