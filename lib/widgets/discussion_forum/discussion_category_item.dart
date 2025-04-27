import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '/screens/discussion_forum/discussion_forum_list_screen.dart';
import '/models/discussion_category.dart';
import '/res/app_colors.dart';
import '/global_configs.dart';
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

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return DiscussionForumListScreen(category: category);
            },
          ),
        );
      },
      child: Row(
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
                          "${category.discussionCount.toString().toPersianDigit()} گفتگو",
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
          const SizedBox(width: 10),
          Container(
            padding: globalAllPadding / 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.surface,
            ),
            child: ClipOval(
              child: CustomCachedImage(
                url: category.image,
                width: 60,
                height: 60,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
