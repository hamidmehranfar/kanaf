import 'package:flutter/material.dart';
import 'package:kanaf/res/enums/message_type.dart';

import '/global_configs.dart';

void showSnackbarMessage(
    {required BuildContext context,
    required String message,
    MessageType? type}) {
  type = type ?? MessageType.failure;
  var theme = Theme.of(context);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        padding: globalAllPadding * 5,
        decoration: BoxDecoration(
          borderRadius: globalBorderRadius * 4,
          color: type == MessageType.failure
              ? theme.colorScheme.error
              : theme.colorScheme.secondary,
        ),
        child: Text(
          message,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.surface,
          ),
        ),
      ),
    ),
  );
}
