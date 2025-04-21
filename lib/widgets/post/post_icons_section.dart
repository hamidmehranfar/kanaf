import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '/controllers/post_controller.dart';
import '/models/post.dart';
import '/res/controllers_key.dart';

class PostIconsSection extends StatefulWidget {
  final Post post;

  const PostIconsSection({
    super.key,
    required this.post,
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
        isPostLiked = !isPostLiked;
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
          child: SvgPicture.asset(
            "assets/icons/message.svg",
            width: 21,
            height: 21,
          ),
        ),
        const SizedBox(width: 20),
        likeOperationLoading
            ? SizedBox(
                width: 32,
                height: 32,
                child: SpinKitThreeBounce(
                  color: theme.colorScheme.secondary,
                  size: 20,
                ),
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
        const SizedBox(width: 16),
      ],
    );
  }
}
