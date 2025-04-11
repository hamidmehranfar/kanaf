import 'package:flutter/material.dart';
import 'package:kanaf/models/calculate_material.dart';
import 'package:kanaf/widgets/custom_cached_image.dart';

import '/global_configs.dart';
import '/widgets/my_divider.dart';
import '/widgets/custom_appbar.dart';

class CalculateResultScreen extends StatefulWidget {
  final CalculateMaterial material;
  final List<(String, String)> result;

  const CalculateResultScreen({
    super.key,
    required this.result,
    required this.material,
  });

  @override
  State<CalculateResultScreen> createState() => _CalculateResultScreenState();
}

class _CalculateResultScreenState extends State<CalculateResultScreen> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppbar(
        onTap: () {
          Navigator.of(context).pop();
        },
        iconAsset: "assets/icons/arrow_back_19.png",
      ),
      body: Padding(
        padding: globalPadding * 7.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            Center(
              child: Text(
                "نتیجه محاسبات",
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: theme.colorScheme.tertiary,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: globalPadding * 3.5,
              child: MyDivider(
                color: theme.colorScheme.onSecondary,
                height: 1,
                thickness: 1,
              ),
            ),
            const SizedBox(height: 13),
            Expanded(
              child: Container(
                padding: globalPadding * 11,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: globalBorderRadius * 6,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 28),
                    ClipRRect(
                      borderRadius: globalBorderRadius * 5,
                      child: CustomCachedImage(
                        url: widget.material.image,
                        width: 265,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Expanded(
                      child: Container(
                        padding: globalPadding * 4,
                        decoration: BoxDecoration(
                          borderRadius: globalBorderRadius * 4,
                          color: theme.colorScheme.tertiary
                              .withValues(alpha: 0.15),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            Expanded(
                              child: ListView.separated(
                                itemBuilder: (context, index) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        widget.result[index].$1,
                                        style:
                                            theme.textTheme.bodyLarge?.copyWith(
                                          color: theme.colorScheme.secondary
                                              .withValues(alpha: 0.5),
                                        ),
                                      ),
                                      Text(
                                        widget.result[index].$2,
                                        style:
                                            theme.textTheme.bodyLarge?.copyWith(
                                          color: theme.colorScheme.secondary
                                              .withValues(alpha: 0.5),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const SizedBox(height: 40);
                                },
                                itemCount: widget.result.length,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
