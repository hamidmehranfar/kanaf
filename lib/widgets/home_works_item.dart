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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            padding: globalAllPadding * 4,
            margin: globalPadding * 2,
            decoration: BoxDecoration(
                borderRadius: globalBorderRadius *2,
                color: theme.colorScheme.secondary.withOpacity(0.3)
            ),
            child:
            Image.asset("assets/images/user.png", fit: BoxFit.fill,),
          ),
          SizedBox(
            width: 100,
            child: Text(text,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
