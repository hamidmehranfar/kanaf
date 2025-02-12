import 'package:flutter/material.dart';
import '/../global_configs.dart';

class ButtonItem extends StatelessWidget {
  final Function()? onTap;
  final bool isButtonDisable;
  final String title;
  final Color color;
  final double width;
  final double height;
  final TextStyle? textStyle;

  const ButtonItem({super.key, required this.onTap,
    required this.title, required this.color,
    this.width = 200, this.height = 50, this.textStyle,
    this.isButtonDisable = false,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return FilledButton(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: globalBorderRadius * 3
        ),
        fixedSize: Size(width, height),
      ),
      child: Text(title, style: textStyle ?? theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w400
      ),),
    );
  }
}
