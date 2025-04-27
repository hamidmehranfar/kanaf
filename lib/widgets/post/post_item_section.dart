import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanaf/controllers/post_controller.dart';
import 'package:kanaf/res/controllers_key.dart';

import '/widgets/post/post_caption_section.dart';
import '/widgets/post/post_comment_section.dart';
import '/widgets/post/post_icons_section.dart';
import '/global_configs.dart';
import '/widgets/post/display_media_section.dart';
import '/models/post.dart';
import '/widgets/post/post_header_section.dart';

class PostItemSection extends StatefulWidget {
  final Post post;
  final int index;

  const PostItemSection({
    super.key,
    required this.post,
    required this.index,
  });

  @override
  State<PostItemSection> createState() => _PostItemSectionState();
}

class _PostItemSectionState extends State<PostItemSection> {
  bool isLoading = true;
  bool isFailed = false;

  bool isCommentVisible = false;

  bool isVideoStop = false;

  PostController postController = Get.find(
    tag: ControllersKey.postControllerKey,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: globalPadding * 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostHeaderSection(
            key: ValueKey("post header index : ${widget.index}"),
            name: "${widget.post.user.firstName} ${widget.post.user.lastName}",
            avatar: widget.post.user.avatar ?? '',
          ),
          DisplayMediaSection(
            key: ValueKey("post media index : ${widget.index}"),
            items: widget.post.items,
            radius: 40,
            index: widget.index,
          ),
          const SizedBox(height: 5),
          PostIconsSection(
            key: ValueKey("post icons index : ${widget.index}"),
            post: widget.post,
            onTap: () {
              setState(() {
                isCommentVisible = !isCommentVisible;
              });
            },
          ),
          Padding(
            padding: globalPadding * 3,
            child: Text(
              "${widget.post.likeCount} لایک",
              style: TextStyle(
                color: const Color(0xFFD9D9D9).withValues(alpha: 0.8),
              ),
            ),
          ),
          const SizedBox(height: 4),
          PostCaptionSection(post: widget.post),
          PostCommentSection(
            key: ValueKey("post comment index : ${widget.index}"),
            post: widget.post,
            isCommentVisible: isCommentVisible,
            onTap: () {
              setState(() {
                isCommentVisible = !isCommentVisible;
              });
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
