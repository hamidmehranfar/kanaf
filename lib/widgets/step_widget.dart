import 'package:flutter/material.dart';

import '../global_configs.dart';

class StepWidget extends StatelessWidget {
  final double width;
  final double height;
  final int selectedIndex;
  final int length;

  const StepWidget({
    super.key,
    this.width = 52,
    this.height = 11,
    required this.selectedIndex,
    required this.length,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        length,
        (int index) {
          return Row(
            children: [
              Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: globalBorderRadius * 2,
                  color: index == (length - selectedIndex - 1)
                      ? theme.colorScheme.secondary
                      : theme.colorScheme.tertiary,
                ),
              ),
              if (index != length - 1) const SizedBox(width: 4),
            ],
          );
        },
      ),
    );
  }
}
