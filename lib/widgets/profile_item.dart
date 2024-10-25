import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProfileItem extends StatelessWidget {
  final Function() onTap;
  final String title;
  final IconData icon;
  const ProfileItem({super.key, required this.onTap,
    required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon),
            const SizedBox(width: 24,),
            Text(title, style: theme.textTheme.titleLarge,)
          ],
        ),
        InkWell(
          onTap: onTap,
          child: const Icon(Iconsax.arrow_left_2),
        ),
      ],
    );
  }
}
