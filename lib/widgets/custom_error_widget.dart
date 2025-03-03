import 'package:flutter/material.dart';

import '../controllers/size_controller.dart';
import '../global_configs.dart';

class CustomErrorWidget extends StatelessWidget {
  final VoidCallback onTap;

  const CustomErrorWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: globalPadding * 6,
        width: SizeController.width(context),
        height: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "تلاش مجدد",
              style: theme.textTheme.bodyLarge
                  ?.copyWith(color: theme.colorScheme.error),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.refresh),
          ],
        ),
      ),
    );
  }
}
