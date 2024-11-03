import 'package:flutter/material.dart';
import 'package:kanaf/global_configs.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return InkWell(
      onTap: (){},
      child: Container(
        width: 160,
        height: 43,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: globalBorderRadius * 3,
          border: Border.all(
            color: theme.colorScheme.onSurface,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.secondary.withOpacity(0.4),
              blurRadius: 30,
              spreadRadius: 10,
              offset: const Offset(0,10),
            )
          ]
        ),
        child: Center(
          child: Text("ارسال کد", style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.tertiaryContainer,
          ),),
        ),
      ),
    );
  }
}
