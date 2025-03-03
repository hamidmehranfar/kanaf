import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/res/enums/master_request_types.dart';

class ActivateProfileStatus extends StatelessWidget {
  final MasterRequestTypes type;
  final String? text;
  final VoidCallback? onTap;

  const ActivateProfileStatus({
    super.key,
    required this.type,
    this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),
        if (type == MasterRequestTypes.inProgress) ...[
          Text(
            'درخواست شما در انتظار تایید است',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              Get.back();
            },
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.tertiary,
            ),
            child: Text(
              "بستن",
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onTertiary,
              ),
            ),
          ),
        ] else ...[
          Text(
            "رد شده",
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            text ?? '',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () {
              Get.back();
              if (onTap != null) {
                onTap!();
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.tertiary,
            ),
            child: Text(
              "ارسال مجدد",
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onTertiary,
              ),
            ),
          ),
        ],
        const SizedBox(height: 20),
      ],
    );
  }
}
