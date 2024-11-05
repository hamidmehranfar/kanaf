import 'package:flutter/material.dart';
import '/../global_configs.dart';

class ProfileItem extends StatelessWidget {
  final Function() onTap;
  final String title;
  final Color color;
  const ProfileItem({super.key, required this.onTap,
    required this.title, required this.color});

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
        fixedSize: const Size(200, 50),
      ),
      child: Text(title, style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w400
      ),),
    );
  }
}
