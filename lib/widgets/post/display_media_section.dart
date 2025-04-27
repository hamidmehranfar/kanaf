import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '/controllers/post_controller.dart';
import '/res/controllers_key.dart';
import '/models/post_item.dart';
import '/controllers/size_controller.dart';
import '/res/enums/media_type.dart';
import '../custom_cached_image.dart';
import '../custom_shimmer.dart';
import '../step_widget.dart';

class DisplayMediaSection extends StatefulWidget {
  final List<PostItem> items;
  final double? radius;
  final int index;

  const DisplayMediaSection({
    super.key,
    required this.items,
    required this.index,
    required this.radius,
  });

  @override
  State<DisplayMediaSection> createState() => _DisplayMediaSectionState();
}

class _DisplayMediaSectionState extends State<DisplayMediaSection> {
  bool isVideoLoading = false;

  bool isStop = false;

  int itemCurrentIndex = 0;
  int videoPlayedIndex = 0;

  PostController postController = Get.find(
    tag: ControllersKey.postControllerKey,
  );

  @override
  void initState() {
    super.initState();
    if ((widget.items.isNotEmpty) &&
        widget.items[itemCurrentIndex].itemType == MediaType.video) {
      fetchVideo(itemCurrentIndex, false);
    }
  }

  Future<void> fetchVideo(int index, bool isCarousal) async {
    String url = widget.items[index].file;

    bool isUrlExist = false;
    for (var mapIndex
        in postController.videoControllers[widget.index].$1.keys) {
      if (mapIndex == index) {
        isUrlExist = true;
        break;
      }
    }

    if (!isCarousal || !isUrlExist) {
      setState(() {
        isVideoLoading = true;
      });

      VideoPlayerController temp =
          VideoPlayerController.networkUrl(Uri.parse(url));

      postController.videoControllers[widget.index].$1[index] = temp;

      await temp.initialize();

      temp.setLooping(true);

      if (postController.postCurrentIndex.value == widget.index &&
          index == postController.videoControllers[widget.index].$2) {
        postController.currentPlayedVideoController?.pause();
        postController.currentPlayedVideoController = temp;
        temp.play();
      } else {
        temp.pause();
      }

      setState(() {
        isVideoLoading = false;
      });
    } else {
      if (postController.currentPlayedVideoController !=
          postController.videoControllers[widget.index].$1[index]) {
        postController.currentPlayedVideoController?.pause();
        postController.videoControllers[widget.index].$1[index]?.play();

        postController.currentPlayedVideoController =
            postController.videoControllers[widget.index].$1[index];
      } else {
        postController.currentPlayedVideoController?.play();
      }

      var temp = postController.videoControllers[widget.index].$1;
      postController.videoControllers[widget.index] = (temp, index, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
      children: [
        CarouselSlider(
          items: List.generate(
            widget.items.length,
            (int index) {
              return widget.items[index].itemType == MediaType.image
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(
                          widget.radius != null ? widget.radius! : 0),
                      child: CustomCachedImage(
                        url: widget.items[index].file,
                        fit: BoxFit.cover,
                        height: 355,
                        width: SizeController.width(context),
                      ),
                    )
                  : SizedBox(
                      height: 360,
                      child: Column(
                        children: [
                          if (isVideoLoading) ...[
                            CustomShimmer(
                              child: Container(
                                height: 355,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.onSurface,
                                  borderRadius: widget.radius != null
                                      ? BorderRadius.circular(widget.radius!)
                                      : null,
                                ),
                              ),
                            )
                          ] else ...[
                            Expanded(
                              child: InkWell(
                                child: Container(
                                  height: 355,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: widget.radius == null
                                        ? null
                                        : BorderRadius.circular(widget.radius!),
                                    color: Colors.grey.withValues(alpha: 0.3),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        widget.radius == null
                                            ? 0
                                            : widget.radius!),
                                    child: AspectRatio(
                                      aspectRatio: postController
                                          .videoControllers[widget.index]
                                          .$1[videoPlayedIndex]!
                                          .value
                                          .aspectRatio,
                                      child: VideoPlayer(
                                        postController
                                            .videoControllers[widget.index]
                                            .$1[videoPlayedIndex]!,
                                      ),
                                    ),
                                  ),
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
            height: 360,
            viewportFraction: 1,
            enableInfiniteScroll: false,
            initialPage: itemCurrentIndex,
            onPageChanged: (index, changeReason) {
              if (widget.items[index].itemType == MediaType.video) {
                videoPlayedIndex = index;
                fetchVideo(videoPlayedIndex, true);
              } else {
                postController.currentPlayedVideoController?.pause();

                var tempControllers =
                    postController.videoControllers[widget.index].$1;
                var tempIndex =
                    postController.videoControllers[widget.index].$2;
                postController.videoControllers[widget.index] =
                    (tempControllers, tempIndex, false);
              }
              setState(() {
                itemCurrentIndex = index;
              });
            },
          ),
        ),
        if ((widget.items.length) > 1) ...[
          const SizedBox(height: 8),
          StepWidget(
            width: 37,
            height: 8,
            selectedIndex: itemCurrentIndex,
            length: widget.items.length,
          ),
        ],
      ],
    );
  }
}
