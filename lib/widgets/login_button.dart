import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '/../global_configs.dart';

class LoginButton extends StatelessWidget {
  final bool isLoading;
  final Function() onTap;
  const LoginButton({super.key,
    required this.isLoading,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return InkWell(
      onTap: isLoading ? null : onTap,
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
        child: isLoading ? SpinKitThreeBounce(
          size: 20,
          color: theme.colorScheme.onPrimary,
        ) :
        Center(
          child: Text("ارسال کد", style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.tertiaryContainer,
            fontWeight: FontWeight.w500
          ),),
        ),
      ),
    );
  }
}
