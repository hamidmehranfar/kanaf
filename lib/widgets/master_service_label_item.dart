import 'package:flutter/material.dart';

import '../global_configs.dart';

class MasterServiceLabelItem extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  const MasterServiceLabelItem({super.key,
    required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: globalPadding * 6,
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Text(label, style: theme.textTheme.headlineLarge?.copyWith(
                  color: theme.colorScheme.tertiary,
                  fontWeight: FontWeight.w300
              ),),
            ),
          ),
          TextButton(
            onPressed: onPressed ,
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap
            ),
            child: Text("مشاهده همه",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.tertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
