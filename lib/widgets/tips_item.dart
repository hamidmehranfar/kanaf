import 'package:flutter/material.dart';
import 'package:kanaf/global_configs.dart';
import 'package:kanaf/widgets/custom_cached_image.dart';
import 'package:kanaf/widgets/my_divider.dart';

import '../models/tip.dart';
import 'small_button.dart';

class TipsItem extends StatelessWidget {
  final Tip item;

  const TipsItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      padding: globalPadding * 14,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: globalBorderRadius * 6,
      ),
      child: Column(
        children: [
          const SizedBox(height: 9),
          Text(
            item.title,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 8),
          CustomCachedImage(
            url: item.image,
            width: 163,
            height: 163,
          ),
          const SizedBox(height: 10),
          MyDivider(
            color: theme.colorScheme.onSecondary,
            height: 2,
            thickness: 2,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  item.description,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontSize: 8,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: SmallButton(
                  text: "جزئیات",
                  textColor: theme.colorScheme.onPrimary,
                  width: 73,
                  height: 23,
                  shadow: [
                    BoxShadow(
                      color: theme.colorScheme.onPrimary,
                      offset: const Offset(-15, -10),
                      blurRadius: 50,
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
