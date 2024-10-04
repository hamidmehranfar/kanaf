import 'package:flutter/material.dart';
import 'package:kanaf/global_configs.dart';

class HomeWorksItem extends StatelessWidget {
  final String text;
  final void Function() onTap;
  const HomeWorksItem({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 60,
        padding: globalPadding,
        decoration: BoxDecoration(
          borderRadius: globalBorderRadius *2,
          color: theme.colorScheme.primary.withOpacity(0.3)
        ),
        child: Center(
          child: Text(text,
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
