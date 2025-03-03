import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kanaf/global_configs.dart';

class HomeWorksItem extends StatelessWidget {
  final String text;
  final SvgPicture imageIcon;
  final void Function() onTap;

  const HomeWorksItem(
      {super.key,
      required this.text,
      required this.onTap,
      required this.imageIcon});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 100,
        width: 80,
        padding: globalPadding * 3.5,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: theme.colorScheme.primary),
        child: Column(
          children: [
            const SizedBox(
              height: 18,
            ),
            SizedBox(
              height: 40,
              child: imageIcon,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              text,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
