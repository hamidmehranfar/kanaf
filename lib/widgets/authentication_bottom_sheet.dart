import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kanaf/controllers/size_controller.dart';

import '../global_configs.dart';

class AuthenticationBottomSheet extends StatelessWidget {
  final bool isLoading;
  final Function() onTap;
  const AuthenticationBottomSheet({
    super.key,
    required this.isLoading,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilledButton(
          onPressed: onTap,
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: globalBorderRadius,
            ),
            fixedSize: Size((SizeController.width(context) ?? 100) - 32, 50)
          ),
          child:
            isLoading ? SizedBox(
              height: 20,
              child: SpinKitThreeBounce(
                color: theme.colorScheme.surface,
                size: 20,
              ),
            ) :
          Text("وارد شوید", style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onPrimary
          ),)
        ),
      ],
    );
  }
}
