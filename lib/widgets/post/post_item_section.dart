import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/widgets/post/post_caption_section.dart';
import '/widgets/post/post_comment_section.dart';
import '/widgets/post/post_icons_section.dart';
import '/global_configs.dart';
import '/widgets/post/display_media_section.dart';
import '/controllers/post_controller.dart';
import '/res/controllers_key.dart';
import '/models/post.dart';
import '/widgets/post/post_header_section.dart';

class PostItemSection extends StatefulWidget {
  final Post post;

  const PostItemSection({
    super.key,
    required this.post,
  });

  @override
  State<PostItemSection> createState() => _PostItemSectionState();
}

class _PostItemSectionState extends State<PostItemSection> {
  bool isLoading = true;
  bool isFailed = false;

  PostController postController = Get.find(
    tag: ControllersKey.postControllerKey,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PostHeaderSection(
          name: "${widget.post.user.firstName} ${widget.post.user.lastName}",
          avatar: widget.post.user.avatar ?? '',
        ),
        DisplayMediaSection(items: widget.post.items),
        const SizedBox(height: 5),
        PostIconsSection(post: widget.post),
        Padding(
          padding: globalPadding * 3,
          child: Text("${widget.post.likeCount} لایک"),
        ),
        const SizedBox(height: 4),
        PostCaptionSection(post: widget.post),
        PostCommentSection(post: widget.post),
        const SizedBox(height: 16),
      ],
    );
  }
}
