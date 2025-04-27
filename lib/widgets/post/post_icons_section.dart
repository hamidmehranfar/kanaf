import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../error_snack_bar.dart';
import '/controllers/post_controller.dart';
import '/models/post.dart';
import '/res/controllers_key.dart';

class PostIconsSection extends StatefulWidget {
  final Post post;
  final Function() onTap;

  const PostIconsSection({
    super.key,
    required this.post,
    required this.onTap,
  });

  @override
  State<PostIconsSection> createState() => _PostIconsSectionState();
}

class _PostIconsSectionState extends State<PostIconsSection> {
  bool isPostLiked = false;
  bool likeOperationLoading = false;
  int? likeId;

  PostController postController = Get.find(
    tag: ControllersKey.postControllerKey,
  );

  @override
  void initState() {
    super.initState();
    isPostLiked = widget.post.isCurrentUserLiked ?? false;
  }

  Future<void> dislikePost() async {
    setState(() {
      likeOperationLoading = true;
    });
    await postController.deletePostLikes(likeId ?? -1).then((value) {
      if (value) {
        if (value) {
          isPostLiked = !isPostLiked;
        } else {
          showSnackbarMessage(
            context: context,
            message: postController.apiMessage,
          );
        }
      }
    });

    setState(() {
      likeOperationLoading = false;
    });
  }

  Future<void> likePost() async {
    setState(() {
      likeOperationLoading = true;
    });

    await postController.createPostLikes(widget.post.id).then((value) {
      if (value.$1) {
        isPostLiked = !isPostLiked;
        likeId = value.$2;
      } else {
        showSnackbarMessage(
          context: context,
          message: postController.apiMessage,
        );
      }
    });

    setState(() {
      likeOperationLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {
            widget.onTap();
          },
          child: SvgPicture.asset(
            "assets/icons/message.svg",
            width: 21,
            height: 21,
          ),
        ),
        const SizedBox(width: 20),
        SizedBox(
          width: 32,
          height: 32,
          child: likeOperationLoading
              ? SpinKitThreeBounce(
                  color: theme.colorScheme.secondary,
                  size: 20,
                )
              : InkWell(
                  onTap: () async {
                    if (isPostLiked) {
                      await dislikePost();
                    } else {
                      await likePost();
                    }
                  },
                  child: Icon(
                    isPostLiked ? Icons.favorite : Icons.favorite_border,
                    size: 28,
                    color: theme.colorScheme.secondary,
                  ),
                ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
