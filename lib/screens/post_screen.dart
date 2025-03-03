import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '/res/enums/media_type.dart';
import '/widgets/custom_error_widget.dart';
import '/widgets/custom_shimmer.dart';
import '/controllers/post_controller.dart';
import '/res/controllers_key.dart';
import '/widgets/custom_cached_image.dart';
import '/models/post.dart';
import '/global_configs.dart';
import '/widgets/custom_appbar.dart';

class PostScreen extends StatefulWidget {
  final int postId;

  const PostScreen({
    super.key,
    required this.postId,
  });

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  int imagesCurrentIndex = 0;

  bool isLoading = true;
  bool isFailed = false;

  bool isVideoLoading = false;
  bool isVideoCompleted = false;

  bool isStop = false;

  Post? post;

  PostController postController = Get.find(
    tag: ControllersKey.postControllerKey,
  );

  Map<String, VideoPlayerController?> controllers = {};

  @override
  void initState() {
    super.initState();
    fetchPost();
  }

  Future<void> fetchPost() async {
    setState(() {
      isLoading = true;
      isFailed = false;
    });

    await postController.getPostDetails(widget.postId).then((value) {
      if (value != null) {
        post = value;
      } else {
        isFailed = true;
      }
    });

    if ((post?.items.isNotEmpty ?? false) &&
        post?.items[imagesCurrentIndex].itemType == MediaType.video) {
      fetchVideo(post?.items[imagesCurrentIndex].file ?? '');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();

    controllers.forEach((key, value) {
      value?.dispose();
    });
  }

  Future<void> fetchVideo(String url) async {
    setState(() {
      isVideoLoading = true;
    });

    if (controllers[url] == null) {
      isVideoCompleted = false;
      controllers[url] = VideoPlayerController.networkUrl(Uri.parse(url));

      await controllers[url]!.initialize();

      controllers[url]!.addListener(() {
        if (controllers[url]!.value.isCompleted) {
          setState(() {
            isVideoCompleted = true;
            isStop = true;
          });
        }
      });

      controllers[url]!.play();
    }

    setState(() {
      isVideoLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppbar(
        iconAsset: "assets/icons/arrow_back_19.png",
        onTap: () => Get.back(),
      ),
      body: ListView(
        padding: globalPadding * 5,
        shrinkWrap: true,
        children: [
          if (isLoading) ...[
            const SizedBox(height: 16),
            CustomShimmer(
              child: Container(
                height: 570,
                decoration: BoxDecoration(
                  borderRadius: globalBorderRadius * 4,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            )
          ] else if (isFailed)
            CustomErrorWidget(
              onTap: () {
                fetchPost();
              },
            )
          else ...[
            const SizedBox(height: 16),
            CarouselSlider(
              items: List.generate(
                post?.items.length ?? 0,
                (int index) {
                  return post?.items[index].itemType == MediaType.image
                      ? ClipRRect(
                          borderRadius: globalBorderRadius * 4,
                          child: CustomCachedImage(
                            url: post?.items[index].file ?? '',
                            fit: BoxFit.cover,
                            height: 600,
                          ),
                        )
                      : SizedBox(
                          height: 600,
                          child: Column(
                            children: [
                              if (isVideoLoading) ...[
                                CustomShimmer(
                                  child: Container(
                                    height: 570,
                                    decoration: BoxDecoration(
                                      borderRadius: globalBorderRadius * 4,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                )
                              ] else ...[
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      isStop = !isStop;

                                      setState(() {
                                        if (isVideoCompleted) {
                                          isVideoCompleted = false;
                                          controllers[post?.items[index].file]!
                                              .seekTo(
                                            const Duration(seconds: 0),
                                          );
                                        }
                                        if (isStop) {
                                          controllers[post?.items[index].file]!
                                              .pause();
                                        } else {
                                          controllers[post?.items[index].file]!
                                              .play();
                                        }
                                      });
                                    },
                                    child: Stack(
                                      children: [
                                        SizedBox(
                                          height: 600,
                                          child: AspectRatio(
                                            aspectRatio: controllers[
                                                    post?.items[index].file]!
                                                .value
                                                .aspectRatio,
                                            child: FittedBox(
                                              fit: BoxFit.cover,
                                              child: SizedBox(
                                                width: controllers[post
                                                        ?.items[index].file]!
                                                    .value
                                                    .size
                                                    .width,
                                                height: controllers[post
                                                        ?.items[index].file]!
                                                    .value
                                                    .size
                                                    .height,
                                                child: VideoPlayer(
                                                  controllers[
                                                      post?.items[index].file]!,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          bottom: 0,
                                          right: 0,
                                          left: 0,
                                          child: Icon(
                                            isStop
                                                ? Icons.play_circle
                                                : Icons.pause_circle,
                                            size: 56,
                                            color: theme.colorScheme.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                              ]
                            ],
                          ),
                        );
                },
              ),
              options: CarouselOptions(
                height: 600,
                viewportFraction: 1,
                enableInfiniteScroll: false,
                initialPage: imagesCurrentIndex,
                onPageChanged: (index, changeReason) {
                  if (post?.items[index].itemType == MediaType.video) {
                    fetchVideo(post?.items[index].file ?? '');
                  }
                  setState(() {
                    imagesCurrentIndex = index;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "بیو",
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              post?.caption ?? '',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}
