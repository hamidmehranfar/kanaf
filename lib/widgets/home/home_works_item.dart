import 'package:flutter/material.dart';
import 'package:kanaf/global_configs.dart';

class HomeWorksItem extends StatelessWidget {
  final String text;
  final Image imageIcon;
  final void Function() onTap;
  const HomeWorksItem({super.key, required this.text,
    required this.onTap, required this.imageIcon});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 160,
        padding: globalPadding * 5,
        decoration: BoxDecoration(
          borderRadius: globalBorderRadius * 10,
          color: theme.colorScheme.primary
        ),
        child: Column(
          children: [
            const SizedBox(height: 30,),
            SizedBox(
              height: 50,
              child: imageIcon
            ),
            const SizedBox(height: 20,),
            SizedBox(
              width: 60,
              child: Text(text,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
                padding: EdgeInsets.zero,
                width : 50,
                height: 20,
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiary.withOpacity(0.75),
                  borderRadius: globalBorderRadius * 3,
                  border: Border.all(
                    color: theme.colorScheme.onSurface.withOpacity(0.5)
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.onPrimary,
                      offset: const Offset(-10, -15),
                      blurRadius: 38,
                    )
                  ]
                ),
                child: Center(
                  child: Text("ورود", style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onPrimary
                  ),),
                )
            )
          ],
        ),
      ),
    );
  }
}
