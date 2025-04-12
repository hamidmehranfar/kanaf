import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '/models/post.dart';
import '/controllers/post_controller.dart';
import '/res/controllers_key.dart';
import '/widgets/button_item.dart';
import '/widgets/profile/story_section.dart';
import '/global_configs.dart';
import '/widgets/custom_appbar.dart';
import '/widgets/my_divider.dart';
import '/widgets/profile/post_section.dart';

class CreatePostStoryScreen extends StatefulWidget {
  final bool isStory;
  final Post? post;

  const CreatePostStoryScreen({
    super.key,
    required this.isStory,
    this.post,
  });

  @override
  State<CreatePostStoryScreen> createState() => _CreatePostStoryScreenState();
}

class _CreatePostStoryScreenState extends State<CreatePostStoryScreen> {
  PostController postController = Get.find(
    tag: ControllersKey.postControllerKey,
  );

  @override
  void initState() {
    super.initState();
    postController.initPostValues();
  }

  Future<void> createPost() async {
    setState(() {
      postController.createPostLoading = true;
    });

    await postController
        .createPost(caption: postController.captionTextController!.text)
        .then(
      (value) {
        if (!value) {
          //FIXME : show error
          print(postController.apiMessage);
        } else {
          //FIXME : show error
          print(postController.apiMessage);
          Navigator.of(context).pop(true);
        }
      },
    );

    setState(() {
      postController.createPostLoading = false;
    });
  }

  bool isLoading() {
    bool isImagesLoading = false;
    for (bool loading in postController.createdPostsLoading) {
      if (loading) {
        isImagesLoading = true;
        break;
      }
    }
    return isImagesLoading || postController.createPostLoading;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppbar(
        onTap: () {
          Navigator.of(context).pop();
        },
        iconAsset: "assets/icons/arrow_back_19.png",
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(height: 25),
          Center(
            child: Text(
              widget.isStory ? "استوری جدید" : "پست جدید",
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w300,
                color: theme.colorScheme.tertiary,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: globalPadding * 11,
            child: MyDivider(
              color: theme.colorScheme.onSecondary,
              height: 1,
              thickness: 1,
            ),
          ),
          const SizedBox(height: 17),
          Container(
            margin: globalPadding * 6,
            padding: globalPadding * 7.5,
            decoration: BoxDecoration(
              borderRadius: globalBorderRadius * 6,
              color: theme.colorScheme.primary,
            ),
            child: widget.isStory
                ? StorySection(
                    post: widget.post,
                  )
                : const PostSection(),
          ),
          const SizedBox(height: 9),
          Padding(
            padding: globalPadding * 11,
            child: MyDivider(
              color: theme.colorScheme.onSecondary,
              height: 1,
              thickness: 1,
            ),
          ),
          const SizedBox(height: 12),
          isLoading()
              ? SpinKitThreeBounce(
                  size: 14,
                  color: theme.colorScheme.onSecondary,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonItem(
                      width: 200,
                      height: 50,
                      onTap: () async {
                        await createPost();
                      },
                      title: "ایجاد",
                      color: theme.colorScheme.tertiary,
                    ),
                  ],
                ),
          const SizedBox(height: 200)
        ],
      ),
    );
  }
}
