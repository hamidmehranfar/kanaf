import 'package:flutter/material.dart';
import 'package:kanaf/global_configs.dart';

class HomeWorksItem extends StatelessWidget {
  final String text;
  final void Function() onTap;
  const HomeWorksItem({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      width: 180,
      color: theme.colorScheme.primary.withOpacity(0.15),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              height: 100,
              width: 100,
              padding: globalAllPadding * 4,
              margin: globalAllPadding.copyWith(top: 8, bottom: 8),
              decoration: BoxDecoration(
                  borderRadius: globalBorderRadius *2,
                  color: theme.colorScheme.secondary.withOpacity(0.3)
              ),
              child:
              Image.asset("assets/images/user.png", fit: BoxFit.fill,),
            ),
            SizedBox(
              width: 60,
              child: Text(text,
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
