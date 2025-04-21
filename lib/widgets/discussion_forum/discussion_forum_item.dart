import 'package:flutter/material.dart';
import 'package:kanaf/models/discussion_category.dart';
import 'package:kanaf/res/app_colors.dart';

import '../../global_configs.dart';
import '../custom_cached_image.dart';

class DiscussionForumItem extends StatelessWidget {
  final DiscussionCategory category;

  const DiscussionForumItem({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  category.name,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.surface,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                category.description,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontSize: 8,
                  color: theme.colorScheme.surface,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 10,
                        color: AppColors.sideColor,
                      ),
                      Text(
                        "پیام ها",
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.tertiary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 10,
                        color: AppColors.sideColor,
                      ),
                      Text(
                        "بازدیدها",
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.tertiary,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: globalAllPadding / 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.surface,
          ),
          child: ClipOval(
            child: CustomCachedImage(
              url:  '',
              width: 60,
              height: 60,
            ),
          ),
        ),
      ],
    );
  }
}
