import 'package:flutter/material.dart';

import '/models/offer_project.dart';
import '/widgets/custom_cached_image.dart';
import '/global_configs.dart';

class OfferItem extends StatelessWidget {
  final OfferProject project;

  const OfferItem({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return SizedBox(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${project.masterProfile.firstName ?? ''} ${project.masterProfile.lastName ?? ''}",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.surface,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        project.message,
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
                          "زمان : ${project.duration}",
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.tertiary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          "مبلغ : ${project.price}",
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
              Container(
                padding: globalAllPadding / 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.surface,
                ),
                child: ClipOval(
                  child: CustomCachedImage(
                    url: project.masterProfile.avatar ?? '',
                    width: 60,
                    height: 60,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 24,
                child: FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: globalBorderRadius * 3,
                    ),
                    padding: globalPadding * 2,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    "تایید پیشنهاد",
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontSize: 9,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                height: 24,
                child: FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: globalBorderRadius * 3,
                    ),
                    padding: globalPadding * 2,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    "رد پیشنهاد",
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontSize: 9,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
