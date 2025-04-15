import 'package:flutter/material.dart';

import '/global_configs.dart';
import '/res/app_colors.dart';

class CustomCheckBox extends StatefulWidget {
  final double height;
  final String text;
  final Color color;
  final Function() onTap;
  final bool checkValue;

  const CustomCheckBox({
    super.key,
    required this.height,
    required this.text,
    required this.color,
    required this.onTap,
    required this.checkValue,
  });

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.only(
        top: 13,
        bottom: 13,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        borderRadius: globalBorderRadius * 4,
        color: AppColors.checkBoxColor,
      ),
      child: InkWell(
        onTap: widget.onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.text,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.paleBlack,
              ),
            ),
            SizedBox(
              width: 30,
              height: 26,
              child: Transform.scale(
                scale: 1.4,
                child: IgnorePointer(
                  ignoring: true,
                  child: Checkbox(
                    value: widget.checkValue,
                    onChanged: (value) {},
                    fillColor: !widget.checkValue
                        ? WidgetStatePropertyAll(
                            AppColors.textFieldColor.withValues(alpha: 0.78),
                          )
                        : null,
                    side: BorderSide(
                      color: AppColors.textFieldColor.withValues(alpha: 0.78),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    activeColor: theme.colorScheme.tertiary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
