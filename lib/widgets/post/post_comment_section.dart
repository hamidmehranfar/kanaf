import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../error_snack_bar.dart';
import '/controllers/authentication_controller.dart';
import '/models/post.dart';
import '/controllers/post_controller.dart';
import '/global_configs.dart';
import '/models/post_comment.dart';
import '/res/controllers_key.dart';
import '../custom_cached_image.dart';

class PostCommentSection extends StatefulWidget {
  final Post post;
  final bool isCommentVisible;
  final Function() onTap;

  const PostCommentSection({
    super.key,
    required this.post,
    required this.isCommentVisible,
    required this.onTap,
  });

  @override
  State<PostCommentSection> createState() => _PostCommentSectionState();
}

class _PostCommentSectionState extends State<PostCommentSection> {
  bool isCreateCommentsLoading = false;
  bool isCommentsLoading = false;
  List<PostComment>? comments;

  PostController postController = Get.find(
    tag: ControllersKey.postControllerKey,
  );

  AuthenticationController authController = Get.find(
    tag: ControllersKey.authControllerKey,
  );

  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    fetchComments();
  }

  Future<void> fetchComments() async {
    setState(() {
      isCommentsLoading = true;
    });

    await postController.getPostComments(widget.post.id).then(
      (commentsList) {
        comments = commentsList! + commentsList + commentsList + commentsList;
      },
    );

    if (mounted) {
      setState(() {
        isCommentsLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Comments section trigger
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16,
              top: 5,
              bottom: 5,
            ),
            child: GestureDetector(
              onTap: () {},
              child: Text(
                '${(comments?.length ?? 0).toString().toPersianDigit()} نظر',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color:
                      theme.colorScheme.inverseSurface.withValues(alpha: 0.8),
                ),
              ),
            ),
          ),
        ),
        // Expanded Comments Section
        if (widget.isCommentVisible)
          Container(
            padding: allPadding * 4,
            margin: globalPadding * 4,
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              borderRadius: globalBorderRadius * 2,
              color: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Comment list
                  if (comments != null)
                    ...comments!.map((comment) => _buildCommentItem(comment)),

                  // Add comment section
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        ClipOval(
                          child: CustomCachedImage(
                            url: authController.user?.avatar ?? '',
                            fit: BoxFit.cover,
                            width: 36,
                            height: 36,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: commentController,
                            decoration: const InputDecoration(
                              hintText: 'افزودن نظر',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            if (commentController.text.isNotEmpty) {
                              setState(() {
                                isCreateCommentsLoading = true;
                              });
                              await postController
                                  .createComments(
                                widget.post.id,
                                commentController.text,
                              )
                                  .then(
                                (value) {
                                  if (!value) {
                                    showSnackbarMessage(
                                      context: context,
                                      message: postController.apiMessage,
                                    );
                                  }
                                },
                              );
                              setState(() {
                                isCreateCommentsLoading = false;
                                commentController.clear();
                              });
                            }
                          },
                          child: isCreateCommentsLoading
                              ? SpinKitThreeBounce(
                                  size: 14,
                                  color: theme.colorScheme.primary,
                                )
                              : Text(
                                  'ارسال',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCommentItem(PostComment comment) {
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: CustomCachedImage(
              url: comment.user.avatar ?? '',
              fit: BoxFit.cover,
              width: 30,
              height: 30,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      TextSpan(
                        text:
                            '${comment.user.firstName} ${comment.user.lastName} ',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: comment.comment,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
