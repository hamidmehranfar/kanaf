import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  final Widget child;
  const CustomShimmer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Shimmer.fromColors(
      baseColor: theme.colorScheme.onSurface.withValues(alpha: 0.5),
      highlightColor: theme.colorScheme.onSurface.withValues(alpha: 0.3),
      direction: ShimmerDirection.rtl,
      enabled: true,
      child: child
    );
  }
}
