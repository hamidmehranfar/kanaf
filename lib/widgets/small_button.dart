import 'package:flutter/material.dart';

import '../global_configs.dart';

class SmallButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final double width;
  final double height;
  final List<BoxShadow>? shadow;
  final Function()? onTap;
  const SmallButton({super.key, required this.text,
    required this.width, required this.height,
    this.shadow, required this.textColor, this.onTap});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.zero,
          width : width,
          height: height,
          decoration: BoxDecoration(
              color: theme.colorScheme.tertiary.withValues(alpha: 0.75),
              borderRadius: globalBorderRadius * 3,
              border: Border.all(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5)
              ),
              boxShadow: shadow
          ),
          child: Center(
            child: Text(text, style: theme.textTheme.labelMedium?.copyWith(
                color: textColor
            ),),
          )
      ),
    );
  }
}
