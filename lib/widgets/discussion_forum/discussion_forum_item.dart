import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '/screens/discussion_forum/discussion_forum_chat_screen.dart';
import '/global_configs.dart';
import '/res/app_colors.dart';
import '/models/discussion.dart';
import '../custom_cached_image.dart';

class DiscussionForumItem extends StatelessWidget {
  final Discussion discussion;

  const DiscussionForumItem({
    super.key,
    required this.discussion,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return InkWell(
      onTap: () {
        Get.to(
          DiscussionForumChatScreen(
            discussion: discussion,
          ),
        );
      },
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 10),
                Text(
                  discussion.title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.surface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  discussion.user.firstName ?? '',
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
                          Icons.thumb_up_alt_outlined,
                          size: 10,
                          color: AppColors.sideColor,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          "${discussion.likeCount.toString().toPersianDigit()} لایک",
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.tertiary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.thumb_down_alt_outlined,
                          size: 10,
                          color: AppColors.sideColor,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          "${discussion.dislikeCount.toString().toPersianDigit()} دیسلایک",
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
                url: discussion.user.avatar ?? '',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
