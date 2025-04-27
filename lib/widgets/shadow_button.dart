import 'package:flutter/material.dart';

import '../global_configs.dart';

class ShadowButton extends StatelessWidget {
  final Function() onTap;
  final double? width;
  final String text;
  final List<BoxShadow>? shadow;

  const ShadowButton({
    super.key,
    required this.onTap,
    required this.width,
    required this.text,
    this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.tertiary.withValues(alpha: 0.75),
          borderRadius: globalBorderRadius * 3,
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          boxShadow: shadow ??
              [
                BoxShadow(
                  color: theme.colorScheme.onPrimary,
                  offset: const Offset(-15, -10),
                  blurRadius: 50,
                ),
              ],
        ),
        child: Center(
          child: Text(
            text,
            style: theme.textTheme.labelSmall,
          ),
        ),
      ),
    );
  }
}
