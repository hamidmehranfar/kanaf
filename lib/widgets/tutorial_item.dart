import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '/global_configs.dart';
import '/widgets/custom_cached_image.dart';
import '/widgets/my_divider.dart';
import '/models/tutorial.dart';
import 'small_button.dart';

class TutorialItem extends StatelessWidget {
  final Tutorial item;

  const TutorialItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return InkWell(
      onTap: () async {
        if (await canLaunchUrl(Uri.parse(item.url))) {
          await launchUrl(Uri.parse(item.url));
        } else {
          throw Exception('Could not launch ${item.url}');
        }
      },
      child: Container(
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
            ClipRRect(
              borderRadius: globalBorderRadius * 5,
              child: CustomCachedImage(
                url: item.image,
                width: 163,
                height: 163,
                fit: BoxFit.cover,
              ),
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
                    item.body,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IgnorePointer(
                    ignoring: true,
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
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
