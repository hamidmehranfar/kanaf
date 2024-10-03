import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  final Widget child;
  const CustomShimmer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Shimmer.fromColors(
      baseColor: theme.colorScheme.onSurface.withOpacity(0.12),
      highlightColor: theme.colorScheme.surface.withOpacity(0.1),
      direction: ShimmerDirection.rtl,
      enabled: true,
      child: child
    );
  }
}
