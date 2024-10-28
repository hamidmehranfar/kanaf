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
        children: [
          Image.asset("assets/images/user.png", fit: BoxFit.fill,
            width: 70,
            height: 70,
          ),
          SizedBox(
            width: 60,
            child: Text(text,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
