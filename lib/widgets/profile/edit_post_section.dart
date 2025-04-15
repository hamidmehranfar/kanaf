import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

import '/widgets/custom_shimmer.dart';
import '/res/enums/media_type.dart';
import '/controllers/post_controller.dart';
import '/res/controllers_key.dart';
import '/widgets/my_divider.dart';
import '/global_configs.dart';
import '/res/app_colors.dart';
import '/models/post.dart';
import '/models/post_item.dart';
import '../button_item.dart';
import '../custom_cached_image.dart';

class EditPostSection extends StatefulWidget {
  final Post post;

  const EditPostSection({
    super.key,
    required this.post,
  });

  @override
  State<EditPostSection> createState() => _EditPostSectionState();
}

class _EditPostSectionState extends State<EditPostSection> {
  PostController postController = Get.find(
    tag: ControllersKey.postControllerKey,
  );

  TextEditingController captionTextController = TextEditingController();

  bool isOperationLoading = false;

  List<(String?, Uint8List?)> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initEditValues();
  }

  Future<void> initEditValues() async {
    setState(() {
      isLoading = true;
    });

    postController.initPostValues();

    List<PostItem> items = widget.post.items;
    for (int i = 0; i < items.length; i++) {
      if (items[i].itemType == MediaType.video) {
        posts.add((null, await getFirstFrame(items[i].file)));
      } else {
        posts.add((items[i].file, null));
      }
    }

    captionTextController.text = widget.post.caption;

    setState(() {
      isLoading = false;
    });
  }

  Future<Uint8List?> getFirstFrame(String videoUrl) async {
    try {
      // Get temporary directory
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/temp_video.mp4';

      // Download video using Dio
      Dio dio = Dio();
      await dio.download(videoUrl, filePath);

      // Generate thumbnail from the downloaded file
      final thumbnail = await VideoThumbnail.thumbnailData(
        video: filePath,
        imageFormat: ImageFormat.PNG,
        maxWidth: 128,
        quality: 75,
      );

      return thumbnail;
    } catch (e) {
      return null;
    }
  }

  Future<void> editPost() async {
    if (captionTextController.text.isEmpty) {
      //FIXME : show error
      return;
    }
    if (widget.post.caption == captionTextController.text) {
      Get.back(result: false);
      return;
    }

    setState(() {
      isOperationLoading = true;
    });

    await postController
        .editPostCaption(
      postId: widget.post.id,
      caption: captionTextController.text,
    )
        .then(
      (value) {
        if (value) {
          Get.back(result: true);
        } else {
          //FIXME : show error
        }
      },
    );

    setState(() {
      isOperationLoading = false;
    });
  }

  Future<void> deletePost() async {
    setState(() {
      isOperationLoading = true;
    });

    await postController
        .deletePost(
      postId: widget.post.id,
    )
        .then((value) {
      if (value) {
        Get.back(result: true);
      }
    });

    setState(() {
      isOperationLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 30),
          SizedBox(
            height: 330,
            child: GridView.builder(
              padding: globalPadding * 9,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 6,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 12,
                mainAxisExtent: 95,
              ),
              itemBuilder: (context, index) {
                return isLoading
                    ? CustomShimmer(
                        child: Container(
                          width: 120,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: globalBorderRadius * 10,
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      )
                    : posts.length > index
                        ? ClipRRect(
                            borderRadius: globalBorderRadius * 10,
                            child: posts[index].$1 == null
                                ? Image.memory(
                                    posts[index].$2!,
                                    width: 105,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  )
                                : CustomCachedImage(
                                    url: posts[index].$1!,
                                    width: 105,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                          )
                        : Container(
                            width: 120,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: globalBorderRadius * 10,
                              color: theme.colorScheme.secondary
                                  .withValues(alpha: 0.4),
                            ),
                          );
              },
            ),
          ),
          // const SizedBox(height: 18),
          // if (postController.createPostLoading)
          //   SpinKitThreeBounce(
          //     size: 14,
          //     color: theme.colorScheme.onSecondary,
          //   )
          // else
          //   SmallButton(
          //     text: "آپلود عکس یا ویدئو",
          //     textColor: theme.colorScheme.onSecondary,
          //     width: 142,
          //     height: 27,
          //     shadow: [
          //       BoxShadow(
          //         color: theme.colorScheme.onPrimary,
          //         offset: const Offset(-20, -10),
          //         blurRadius: 25,
          //         spreadRadius: -10,
          //       ),
          //       BoxShadow(
          //         color: theme.colorScheme.onSecondary,
          //         offset: const Offset(20, 10),
          //         blurRadius: 20,
          //         spreadRadius: -5,
          //       ),
          //     ],
          //     onTap: () async {},
          //   ),
          // const SizedBox(height: 25),
          Container(
            height: 51,
            padding: const EdgeInsets.only(bottom: 5),
            margin: globalPadding * 10,
            decoration: BoxDecoration(
              color: AppColors.textFieldColor.withValues(alpha: 0.78),
              borderRadius: globalBorderRadius * 4,
            ),
            child: Row(
              children: [
                const SizedBox(width: 15),
                Expanded(
                  child: TextField(
                    controller: captionTextController,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.surface,
                    ),
                    enabled: !isLoading && !isOperationLoading,
                    scrollPadding: const EdgeInsets.only(bottom: 200),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: "کپشن",
                      hintStyle: theme.textTheme.labelMedium?.copyWith(
                        color:
                            theme.colorScheme.onPrimary.withValues(alpha: 0.38),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8)
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: globalPadding * 5,
            child: const MyDivider(
              color: Color(0xFF333333),
              height: 1,
              thickness: 1,
            ),
          ),
          const SizedBox(height: 12),
          if (isOperationLoading)
            SpinKitThreeBounce(
              size: 14,
              color: theme.colorScheme.onPrimary,
            )
          else
            ButtonItem(
              width: 180,
              height: 40,
              onTap: () async {
                await editPost();
              },
              title: "ذخیره",
              color: theme.colorScheme.tertiary,
            ),
          const SizedBox(height: 8),
          if (isOperationLoading)
            SpinKitThreeBounce(
              size: 14,
              color: theme.colorScheme.onPrimary,
            )
          else
            ButtonItem(
              width: 180,
              height: 40,
              onTap: () async {
                await deletePost();
              },
              title: "حذف پست",
              color: theme.colorScheme.secondary,
            ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
