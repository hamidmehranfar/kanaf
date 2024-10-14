import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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

    return Padding(
      padding: globalAllPadding * 4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilledButton(
            onPressed: onTap,
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: globalBorderRadius,
              ),
            ),
            child:
              isLoading ? SizedBox(
                height: 20,
                child: SpinKitThreeBounce(
                  color: theme.colorScheme.surface,
                  size: 20,
                ),
              ) :
            Text("وارد شوید", style: theme.textTheme.bodyLarge,)
          ),
        ],
      ),
    );
  }
}
